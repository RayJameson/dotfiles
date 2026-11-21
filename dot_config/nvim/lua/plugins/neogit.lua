-- Lazygit's "move patch into index" for Neogit's commit view.
-- <LocalLeader>s toggles lines/hunks/files into a pending patch, <LocalLeader>i removes the patch from the
-- commit (rewriting history) and stages it. With nothing selected, <LocalLeader>i acts on what's under the
-- cursor: change block, visual range, hunk header (whole hunk), file header, or commit header (everything).

local ns = vim.api.nvim_create_namespace("neogit_move_patch")
-- lines[file][hunk_idx][line_idx] = true; files[file] = true means the whole file
local state = { files = {}, lines = {} }

local function git(root, args, opts)
  opts = opts or {}
  local cmd = vim.list_extend({ "git", "-C", root }, args)
  local r = vim.system(cmd, { text = true, stdin = opts.stdin, env = opts.env }):wait()
  return r.code == 0, vim.trim(r.stdout or ""), vim.trim(r.stderr or "")
end

local function fail(msg, err)
  vim.notify(msg .. (err and err ~= "" and ("\n" .. err) or ""), vim.log.levels.ERROR, { title = "Neogit" })
end

local function diff_of(view, file)
  for _, d in ipairs(view.commit_info.diffs) do
    if d.file == file then return d end
  end
end

local function hunk_idx(diff, hunk)
  for i, h in ipairs(diff.hunks) do
    if h == hunk then return i end
  end
end

local function changed(hunk, i) return (hunk.lines[i] or ""):match("^[+-]") ~= nil end

local function count(sel)
  local files, lines = vim.tbl_count(sel.files), 0
  for file, hs in pairs(sel.lines) do
    if not sel.files[file] then
      for _, s in pairs(hs) do
        lines = lines + vim.tbl_count(s)
      end
    end
  end
  return files, lines
end

local function sync(view)
  if state.sha ~= view.commit_info.oid then
    if state.sha and (count(state)) + select(2, count(state)) > 0 then
      vim.notify("Patch selection cleared (different commit)", vim.log.levels.WARN, { title = "Neogit" })
    end
    state = { sha = view.commit_info.oid, files = {}, lines = {} }
  end
end

-- What's under the cursor: { file, diff, hunk, hi, from, to } for a hunk (from/to are unclamped hunk line
-- indices, 0 = @@ header), { file } for a file header, nil otherwise.
local function target(view, mode)
  local a, b = vim.fn.line("."), vim.fn.line(".")
  if mode == "v" then
    a, b = math.min(vim.fn.line("v"), a), math.max(vim.fn.line("v"), b)
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  end
  local hc = view.buffer.ui:get_component_under_cursor(function(c) return c.options.hunk ~= nil end)
  if hc then
    local d, row0 = diff_of(view, hc.options.filepath), hc.position.row_start
    -- A partial patch can't apply against a file the commit deletes.
    if d.kind == "deleted file" then return { file = d.file } end
    return { file = d.file, diff = d, hunk = hc.options.hunk, hi = hunk_idx(d, hc.options.hunk), from = a - row0, to = b - row0 }
  end
  local dc = view.buffer.ui:get_component_under_cursor(function(c) return c.options.diff ~= nil end)
  if dc then return { file = dc.options.diff.file } end
end

-- Resolves a hunk target to the changed line indices it covers.
local function target_lines(t, mode)
  local from, to = math.max(t.from, 1), math.min(t.to, #t.hunk.lines)
  if mode ~= "v" then
    if changed(t.hunk, t.from) then
      while changed(t.hunk, from - 1) do from = from - 1 end
      while changed(t.hunk, to + 1) do to = to + 1 end
      if mode == "line" then from, to = t.from, t.from end
    else
      from, to = 1, #t.hunk.lines
    end
  end
  local idx = {}
  for i = from, to do
    if changed(t.hunk, i) then table.insert(idx, i) end
  end
  return idx
end

local function walk(c, f)
  f(c)
  for _, ch in ipairs(c.children or {}) do
    walk(ch, f)
  end
end

local function draw(view)
  local buf = view.buffer.handle
  if not vim.api.nvim_buf_is_valid(buf) then return end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if state.sha ~= view.commit_info.oid then return end
  local function mark(row)
    vim.api.nvim_buf_set_extmark(buf, ns, row - 1, 0, {
      sign_text = "▌",
      sign_hl_group = "DiagnosticOk",
      line_hl_group = "Visual",
      priority = 300,
    })
  end
  local root = view.buffer.ui.layout
  walk(root.children and root or { children = root }, function(c)
    if c.options and c.options.diff and state.files[c.options.diff.file] then mark(c.position.row_start) end
    if c.options and c.options.hunk then
      local d = diff_of(view, c.options.filepath)
      if d and not state.files[d.file] then
        for i in pairs((state.lines[d.file] or {})[hunk_idx(d, c.options.hunk)] or {}) do
          mark(c.position.row_start + i)
        end
      end
    end
  end)
end

local function toggle(mode)
  local view = require("neogit.buffers.commit_view").instance
  if not view then return end
  sync(view)
  local t = target(view, mode)
  if not t then return end
  if not t.hunk then
    state.files[t.file] = not state.files[t.file] or nil
    state.lines[t.file] = nil
  else
    state.files[t.file] = nil
    state.lines[t.file] = state.lines[t.file] or {}
    local s = state.lines[t.file][t.hi] or {}
    state.lines[t.file][t.hi] = s
    local idx = target_lines(t, mode or "line")
    local all = true
    for _, i in ipairs(idx) do
      all = all and s[i] or false
    end
    for _, i in ipairs(idx) do
      s[i] = (not all) or nil
    end
  end
  draw(view)
end

-- Builds a patch from "commit without the selection" to "commit": unselected `+` lines become context and
-- unselected `-` lines are dropped, so it reverse-applies onto the commit and forward-applies on top of the result.
local function build_patch(view, root, sel)
  local out = {}
  local whole = {}
  for file in pairs(sel.files) do
    -- Renames are keyed "old -> new"; with --no-renames both paths are needed to move the whole rename.
    local old, new = file:match("^(.-) %-> (.+)$")
    vim.list_extend(whole, old and { old, new } or { file })
  end
  if sel.all or #whole > 0 then
    local args = { "show", "--format=", "--binary", "--no-color", "--no-ext-diff", "--no-renames", view.commit_info.oid }
    if not sel.all then vim.list_extend(args, vim.list_extend({ "--" }, whole)) end
    local ok, text, err = git(root, args)
    if not ok then return nil, err end
    table.insert(out, text)
  end
  if sel.all then return table.concat(out, "\n") .. "\n" end

  for file, hs in pairs(sel.lines) do
    local d = diff_of(view, file)
    if d and not sel.files[file] then
      local body, shift = {}, 0 -- shift: line offset of "commit without selection" vs commit so far
      for hi, hunk in ipairs(d.hunks) do
        local s = hs[hi]
        if s and next(s) then
          local lines, a_len, c_len, kept = {}, 0, 0, false
          for i, line in ipairs(hunk.lines) do
            local op = line:sub(1, 1)
            if op == "\\" then
              if kept then table.insert(lines, line) end
            elseif op == "-" then
              kept = s[i] or false
              if kept then
                table.insert(lines, line)
                a_len = a_len + 1
              end
            else
              kept = true
              table.insert(lines, (op == "+" and not s[i]) and (" " .. line:sub(2)) or line)
              if op ~= "+" or not s[i] then a_len = a_len + 1 end
              c_len = c_len + 1
            end
          end
          local c_from = hunk.disk_from
          local a_from = c_from + shift
          if a_len == 0 and c_len > 0 then a_from = a_from - 1 end
          table.insert(body, ("@@ -%d,%d +%d,%d @@"):format(a_from, a_len, c_from, c_len))
          vim.list_extend(body, lines)
          shift = shift + a_len - c_len
        end
      end
      if #body > 0 then
        local path = file:match(" %-> (.+)$") or file
        table.insert(out, "--- a/" .. path)
        table.insert(out, "+++ b/" .. path)
        vim.list_extend(out, body)
      end
    end
  end
  return table.concat(out, "\n") .. "\n"
end

local function move_to_index(mode)
  local view = require("neogit.buffers.commit_view").instance
  if not view then return end
  sync(view)
  local root = require("neogit.lib.git").repo.worktree_root
  local sha = view.commit_info.oid
  local short = sha:sub(1, 8)
  local ok, err

  local _, parents = git(root, { "rev-list", "--parents", "-n1", sha })
  parents = vim.split(parents, " ")
  if #parents > 2 then return fail("Merge commits are not supported") end

  for _, p in ipairs({ "rebase-merge", "rebase-apply", "MERGE_HEAD", "CHERRY_PICK_HEAD" }) do
    local _, path = git(root, { "rev-parse", "--path-format=absolute", "--git-path", p })
    if vim.uv.fs_stat(path) then return fail("Finish the in-progress rebase/merge/cherry-pick first") end
  end
  -- Staged changes would be swallowed by the amend.
  if not git(root, { "diff", "--cached", "--quiet" }) then return fail("Unstage your changes first") end
  local _, head = git(root, { "rev-parse", "HEAD" })
  -- The rebase path applies with --index, which fails on files with unstaged edits.
  if sha ~= head and not git(root, { "diff", "--quiet" }) then
    return fail("Commit or stash your unstaged changes first")
  end

  local sel, what
  local nfiles, nlines = count(state)
  if nfiles + nlines > 0 then
    sel, what = state, ("%d file(s) + %d line(s)"):format(nfiles, nlines)
  else
    local t = target(view, mode)
    sel = { files = {}, lines = {} }
    if not t then
      sel.all, what = true, "all changes"
    elseif not t.hunk then
      sel.files[t.file], what = true, "file " .. t.file
    else
      local idx = target_lines(t, mode)
      if #idx == 0 then return fail("No changed lines selected") end
      sel.lines[t.file] = { [t.hi] = {} }
      for _, i in ipairs(idx) do
        sel.lines[t.file][t.hi][i] = true
      end
      what = ("%d line(s)"):format(#idx)
    end
  end

  local patch, perr = build_patch(view, root, sel)
  if not patch or vim.trim(patch) == "" then return fail("Could not build patch", perr) end
  if vim.fn.confirm(("Move %s out of %s into the index?"):format(what, short), "&Yes\n&No", 2) ~= 1 then return end

  -- Kept in the git dir (not tempname) so the recovery commands in error messages survive quitting nvim.
  local _, gitdir = git(root, { "rev-parse", "--absolute-git-dir" })
  local file = gitdir .. "/neogit-move-to-index.patch"
  vim.fn.writefile(vim.split(patch, "\n", { plain = true }), file, "b")

  if sha == head then
    -- Index-only, so a dirty worktree is left untouched.
    ok, _, err = git(root, { "apply", "--cached", "--reverse", file })
    if not ok then return fail("Reverse apply failed (patch: " .. file .. ")", err) end
    ok, _, err = git(root, { "commit", "--amend", "--no-edit", "--allow-empty", "--allow-empty-message" })
    if not ok then return fail("Amend failed (patch: " .. file .. ")", err) end
    ok, _, err = git(root, { "apply", "--cached", file })
    if not ok then return fail("Re-applying patch to index failed (patch: " .. file .. ")", err) end
  else
    if not git(root, { "merge-base", "--is-ancestor", sha, "HEAD" }) then
      return fail(short .. " is not an ancestor of HEAD")
    end
    local abbrev = select(2, git(root, { "rev-parse", "--short", sha }))
    local env = {
      GIT_SEQUENCE_EDITOR = ("sed -i -E 's/^(pick|p) (%s)( |$)/edit \\2\\3/'"):format(abbrev),
      GIT_EDITOR = ":",
    }
    local base = parents[2] or "--root"
    ok, _, err = git(root, {
      "rebase", "--interactive", "--keep-empty", "--no-autosquash", "--rebase-merges", base,
    }, { env = env })
    local _, stopped = git(root, { "rev-parse", "HEAD" })
    if stopped ~= sha then
      git(root, { "rebase", "--abort" })
      return fail("Could not stop rebase at " .. short, err)
    end

    ok, _, err = git(root, { "apply", "--3way", "--index", "--reverse", file })
    if not ok then
      git(root, { "rebase", "--abort" })
      return fail("Reverse apply failed, rebase aborted (patch: " .. file .. ")", err)
    end
    ok, _, err = git(root, { "commit", "--amend", "--no-edit", "--allow-empty", "--allow-empty-message" })
    if not ok then
      git(root, { "rebase", "--abort" })
      return fail("Amend failed, rebase aborted", err)
    end
    ok, _, err = git(root, { "rebase", "--continue" }, { env = { GIT_EDITOR = ":" } })
    if not ok then
      state = { files = {}, lines = {} }
      require("neogit").dispatch_refresh()
      return fail("Rebase stopped (conflict?). Resolve it, then run: git apply --3way --index " .. file, err)
    end
    ok, _, err = git(root, { "apply", "--3way", "--index", file })
    if not ok then return fail("Re-applying patch to index failed (patch: " .. file .. ")", err) end
  end

  vim.fn.delete(file)
  state = { files = {}, lines = {} }
  view:close()
  require("neogit").dispatch_refresh()
  vim.notify(("Moved %s out of %s into the index"):format(what, short), vim.log.levels.INFO, { title = "Neogit" })
end

local function clear()
  state = { files = {}, lines = {} }
  local view = require("neogit.buffers.commit_view").instance
  if view then draw(view) end
end

---@type LazySpec
return {
  "NeogitOrg/neogit",
  optional = true,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      callback = function(ev)
        local map = function(mode, lhs, fn, desc) vim.keymap.set(mode, lhs, fn, { buffer = ev.buf, desc = desc }) end
        map("n", "<LocalLeader>s", toggle, "Toggle line/hunk/file in patch")
        map("x", "<LocalLeader>s", function() toggle("v") end, "Toggle selected lines in patch")
        map("n", "<LocalLeader>i", move_to_index, "Move patch (or change under cursor) into index")
        map("x", "<LocalLeader>i", function() move_to_index("v") end, "Move selected lines into index")
        map("n", "<LocalLeader>c", clear, "Clear patch selection")
        -- Reopening the same commit re-renders the buffer; redraw the marks.
        vim.schedule(function()
          local view = require("neogit.buffers.commit_view").instance
          if view then draw(view) end
        end)
      end,
    })
  end,
}
