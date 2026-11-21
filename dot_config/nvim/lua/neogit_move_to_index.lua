-- Lazygit's "move patch to index", for Neogit's commit view.
--
--   <LocalLeader>s  add/remove the line, hunk or file under the cursor (or the visual range) to a pending selection
--   <LocalLeader>i  remove the selection from the commit (rewriting history) and stage it
--   <LocalLeader>c  clear the selection
--
-- With nothing selected, <LocalLeader>i uses what's under the cursor: the visual range, the block of changed lines,
-- the whole hunk (cursor on its header or a context line), the whole file (on its header) or the whole commit.
--
-- Relies on Neogit internals (commit_view.instance, buffer.ui components, commit_info.diffs), not a public API.

local M = {}

local ns = vim.api.nvim_create_namespace("neogit_move_to_index")

------------------------------------------------------------------------------------------------------------------------
-- Helpers
------------------------------------------------------------------------------------------------------------------------

local function git(root, args, env)
  local result = vim.system(vim.list_extend({ "git", "-C", root }, args), { text = true, env = env }):wait()
  return result.code == 0, vim.trim(result.stdout or ""), vim.trim(result.stderr or "")
end

local function notify_error(message, details)
  if details and details ~= "" then message = message .. "\n" .. details end
  vim.notify(message, vim.log.levels.ERROR, { title = "Neogit" })
end

local function current_view() return require("neogit.buffers.commit_view").instance end

local function find_diff(view, path)
  for _, diff in ipairs(view.commit_info.diffs) do
    if diff.file == path then return diff end
  end
end

local function index_of(list, item)
  for i, value in ipairs(list) do
    if value == item then return i end
  end
end

local function is_change(line)
  local op = line and line:sub(1, 1)
  return op == "+" or op == "-"
end

------------------------------------------------------------------------------------------------------------------------
-- Selection
--   files[path] = true                         the whole file is selected
--   lines[path][hunk_index][line_index] = true  single lines; line_index points into hunk.lines
-- Paths are Neogit's diff.file, which is "old -> new" for renames.
------------------------------------------------------------------------------------------------------------------------

local selection = { sha = nil, files = {}, lines = {} }

local function reset_selection(sha) selection = { sha = sha, files = {}, lines = {} } end

local function count_selected(sel)
  local line_count = 0
  for _, hunks in pairs(sel.lines) do
    for _, lines in pairs(hunks) do
      line_count = line_count + vim.tbl_count(lines)
    end
  end
  return vim.tbl_count(sel.files), line_count
end

local function is_empty(sel)
  local file_count, line_count = count_selected(sel)
  return file_count + line_count == 0
end

-- The selection belongs to one commit; opening another commit starts a new one.
local function use_selection_of(view)
  local sha = view.commit_info.oid
  if selection.sha == sha then return end
  if selection.sha and not is_empty(selection) then
    vim.notify("Patch selection cleared (different commit)", vim.log.levels.WARN, { title = "Neogit" })
  end
  reset_selection(sha)
end

local function toggle_file(path)
  if selection.files[path] then
    selection.files[path] = nil
  else
    selection.files[path] = true
  end
  selection.lines[path] = nil
end

-- Selects all of line_indices, or unselects them if they were all selected already.
local function toggle_lines(path, hunk_index, line_indices)
  selection.files[path] = nil
  selection.lines[path] = selection.lines[path] or {}
  local selected = selection.lines[path][hunk_index] or {}
  selection.lines[path][hunk_index] = selected

  local all_selected = vim.iter(line_indices):all(function(i) return selected[i] end)
  for _, i in ipairs(line_indices) do
    if all_selected then
      selected[i] = nil
    else
      selected[i] = true
    end
  end
end

------------------------------------------------------------------------------------------------------------------------
-- What's under the cursor
------------------------------------------------------------------------------------------------------------------------

--- Returns
---   { kind = "hunk", path, hunk, hunk_index, first, last }
---       first/last: the cursor (or visual range) as hunk line indices; 0 is the @@ header, may lie outside the hunk
---   { kind = "file", path }
---   nil when the cursor is on the commit header (or anywhere else)
local function cursor_target(view, visual)
  local first, last = vim.fn.line("."), vim.fn.line(".")
  if visual then
    first, last = math.min(vim.fn.line("v"), first), math.max(vim.fn.line("v"), last)
    vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
  end

  local ui = view.buffer.ui
  local hunk_component = ui:get_component_under_cursor(function(c) return c.options.hunk ~= nil end)
  if hunk_component then
    local diff = find_diff(view, hunk_component.options.filepath)
    -- A partial patch can't apply to a file the commit deletes, so treat it as the whole file.
    if diff.kind == "deleted file" then return { kind = "file", path = diff.file } end

    local hunk = hunk_component.options.hunk
    local header_row = hunk_component.position.row_start
    return {
      kind = "hunk",
      path = diff.file,
      hunk = hunk,
      hunk_index = index_of(diff.hunks, hunk),
      first = first - header_row,
      last = last - header_row,
    }
  end

  local file_component = ui:get_component_under_cursor(function(c) return c.options.diff ~= nil end)
  if file_component then return { kind = "file", path = file_component.options.diff.file } end
end

local function changed_lines_between(hunk, first, last)
  local indices = {}
  for i = math.max(first, 1), math.min(last, #hunk.lines) do
    if is_change(hunk.lines[i]) then table.insert(indices, i) end
  end
  return indices
end

-- The run of consecutive +/- lines around line i.
local function change_block_at(hunk, i)
  local first, last = i, i
  while is_change(hunk.lines[first - 1]) do
    first = first - 1
  end
  while is_change(hunk.lines[last + 1]) do
    last = last + 1
  end
  return changed_lines_between(hunk, first, last)
end

--- Changed lines a hunk target refers to:
---   visual range               -> changed lines in the range
---   cursor on a changed line   -> that line, or its whole change block when `whole_block`
---   cursor on header/context   -> every changed line in the hunk
local function target_lines(target, visual, whole_block)
  local hunk = target.hunk
  if visual then return changed_lines_between(hunk, target.first, target.last) end

  local line = target.first
  if not is_change(hunk.lines[line]) then return changed_lines_between(hunk, 1, #hunk.lines) end
  if whole_block then return change_block_at(hunk, line) end
  return { line }
end

------------------------------------------------------------------------------------------------------------------------
-- Highlighting
------------------------------------------------------------------------------------------------------------------------

local function each_component(component, fn)
  fn(component)
  for _, child in ipairs(component.children or {}) do
    each_component(child, fn)
  end
end

local function highlight_selection(view)
  local buf = view.buffer.handle
  if not vim.api.nvim_buf_is_valid(buf) then return end
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  if selection.sha ~= view.commit_info.oid then return end

  local function mark(row)
    vim.api.nvim_buf_set_extmark(buf, ns, row - 1, 0, {
      sign_text = "▌",
      sign_hl_group = "DiagnosticOk",
      line_hl_group = "Visual",
      priority = 300,
    })
  end

  -- The layout is either a single root component or a list of them.
  local layout = view.buffer.ui.layout
  local root = layout.children and layout or { children = layout }
  each_component(root, function(component)
    local options = component.options or {}
    local row = component.position and component.position.row_start

    if options.diff and selection.files[options.diff.file] then mark(row) end

    if options.hunk then
      local diff = find_diff(view, options.filepath)
      local selected_hunks = diff and selection.lines[diff.file]
      local selected = selected_hunks and selected_hunks[index_of(diff.hunks, options.hunk)] or {}
      for line_index in pairs(selected) do
        mark(row + line_index)
      end
    end
  end)
end

------------------------------------------------------------------------------------------------------------------------
-- Patch
--
-- The patch goes from "commit without the selection" (before) to "commit" (after). Reverse-applying it to the commit
-- removes the selection; applying it afterwards puts the selection into the index.
--
-- Hunk lines are rewritten like this:
--   " ctx"            -> " ctx"      context stays context
--   "+new" selected   -> "+new"      stays an addition
--   "+new" unselected -> " new"      stays in the commit, so it's context
--   "-old" selected   -> "-old"      stays a deletion
--   "-old" unselected -> (dropped)   stays deleted, so it's on neither side
------------------------------------------------------------------------------------------------------------------------

local function new_path(path) return path:match(" %-> (.+)$") or path end

--- `offset` is how many more lines "before" has than "after" above this hunk.
--- Returns the rewritten hunk (header first) and the offset below it.
local function rewrite_hunk(hunk, selected, offset)
  local lines = {}
  local before_count, after_count = 0, 0
  local previous_kept = false

  for i, line in ipairs(hunk.lines) do
    local op = line:sub(1, 1)
    if op == "\\" then -- "\ No newline at end of file" belongs to the line above it
      if previous_kept then table.insert(lines, line) end
    elseif op == "-" then
      previous_kept = selected[i] == true
      if previous_kept then
        table.insert(lines, line)
        before_count = before_count + 1
      end
    elseif op == "+" and selected[i] then
      previous_kept = true
      table.insert(lines, line)
      after_count = after_count + 1
    else -- context, or an unselected addition
      previous_kept = true
      table.insert(lines, " " .. line:sub(2))
      before_count = before_count + 1
      after_count = after_count + 1
    end
  end

  local after_start = hunk.disk_from
  local before_start = after_start + offset
  -- Git numbers an empty side by the line before it.
  if before_count == 0 and after_count > 0 then before_start = before_start - 1 end

  table.insert(lines, 1, ("@@ -%d,%d +%d,%d @@"):format(before_start, before_count, after_start, after_count))
  return lines, offset + before_count - after_count
end

--- `git show` of whole files, or of the whole commit when `paths` is nil.
local function whole_file_patch(root, sha, paths)
  local args = { "show", "--format=", "--binary", "--no-color", "--no-ext-diff", "--no-renames", sha }
  if paths then
    table.insert(args, "--")
    for path in pairs(paths) do
      -- With --no-renames a rename is a delete plus an add, so both paths are needed.
      local old, new = path:match("^(.-) %-> (.+)$")
      vim.list_extend(args, old and { old, new } or { path })
    end
  end
  local ok, patch, err = git(root, args)
  if not ok then return nil, err end
  return patch
end

local function build_patch(view, root, sel)
  local sha = view.commit_info.oid
  local parts = {}

  if sel.all or next(sel.files) then
    local patch, err = whole_file_patch(root, sha, not sel.all and sel.files or nil)
    if not patch then return nil, err end
    table.insert(parts, patch)
  end

  for path, selected_hunks in pairs(sel.lines) do
    local diff = find_diff(view, path)
    local file_lines, offset = {}, 0
    for hunk_index, hunk in ipairs(diff.hunks) do
      local selected = selected_hunks[hunk_index]
      if selected and next(selected) then
        local hunk_lines
        hunk_lines, offset = rewrite_hunk(hunk, selected, offset)
        vim.list_extend(file_lines, hunk_lines)
      end
    end
    if #file_lines > 0 then
      table.insert(parts, "--- a/" .. new_path(path))
      table.insert(parts, "+++ b/" .. new_path(path))
      vim.list_extend(parts, file_lines)
    end
  end

  return table.concat(parts, "\n") .. "\n"
end

------------------------------------------------------------------------------------------------------------------------
-- Rewriting the commit
------------------------------------------------------------------------------------------------------------------------

local AMEND = { "commit", "--amend", "--no-edit", "--allow-empty", "--allow-empty-message" }

local function run_steps(root, steps)
  for _, step in ipairs(steps) do
    local ok, _, err = git(root, step.args, step.env)
    if not ok then return false, step.error, err end
  end
  return true
end

--- Returns why the repo isn't safe to rewrite, or nil.
local function repo_problem(root, sha, head)
  for _, name in ipairs { "rebase-merge", "rebase-apply", "MERGE_HEAD", "CHERRY_PICK_HEAD" } do
    local _, path = git(root, { "rev-parse", "--path-format=absolute", "--git-path", name })
    if vim.uv.fs_stat(path) then return "Finish the in-progress rebase/merge/cherry-pick first" end
  end
  -- The amend would include them in the commit.
  if not git(root, { "diff", "--cached", "--quiet" }) then return "Unstage your changes first" end
  if sha == head then return nil end

  -- `apply --index` during the rebase fails on files with unstaged edits.
  if not git(root, { "diff", "--quiet" }) then return "Commit or stash your unstaged changes first" end
  if not git(root, { "merge-base", "--is-ancestor", sha, "HEAD" }) then
    return sha:sub(1, 8) .. " is not an ancestor of HEAD"
  end
end

-- Only touches the index, so unstaged edits are left alone.
local function move_out_of_head(root, patch_file)
  return run_steps(root, {
    { args = { "apply", "--cached", "--reverse", patch_file }, error = "Removing the patch from the commit failed" },
    { args = AMEND, error = "Amending the commit failed" },
    { args = { "apply", "--cached", patch_file }, error = "Staging the patch failed" },
  })
end

-- Stops an interactive rebase at the commit, amends it, replays the later commits, then stages the patch.
local function move_out_of_older_commit(root, patch_file, sha, parent)
  local _, short_sha = git(root, { "rev-parse", "--short", sha })
  -- Turns the todo line "pick <short_sha> <subject>" into "edit <short_sha> <subject>".
  local mark_edit = ("sed -i -E 's/^(pick|p) %s( |$)/edit %s\\2/'"):format(short_sha, short_sha)
  local _, _, rebase_err = git(
    root,
    { "rebase", "--interactive", "--keep-empty", "--no-autosquash", "--rebase-merges", parent or "--root" },
    { GIT_SEQUENCE_EDITOR = mark_edit, GIT_EDITOR = ":" }
  )
  local _, stopped_at = git(root, { "rev-parse", "HEAD" })
  if stopped_at ~= sha then
    git(root, { "rebase", "--abort" })
    return false, "Could not stop the rebase at " .. sha:sub(1, 8), rebase_err
  end

  local ok, message, err = run_steps(root, {
    {
      args = { "apply", "--3way", "--index", "--reverse", patch_file },
      error = "Removing the patch from the commit failed",
    },
    { args = AMEND, error = "Amending the commit failed" },
  })
  if not ok then
    git(root, { "rebase", "--abort" })
    return false, message .. ", rebase aborted", err
  end

  return run_steps(root, {
    {
      args = { "rebase", "--continue" },
      env = { GIT_EDITOR = ":" },
      error = "Rebase stopped (conflict?). Resolve it, then stage the patch with: git apply --3way --index <patch>",
    },
    { args = { "apply", "--3way", "--index", patch_file }, error = "Staging the patch failed" },
  })
end

------------------------------------------------------------------------------------------------------------------------
-- Commands
------------------------------------------------------------------------------------------------------------------------

--- A one-off selection from what's under the cursor, plus a description for messages. nil if nothing is changed there.
local function selection_from_cursor(view, visual)
  local target = cursor_target(view, visual)
  local sel = { files = {}, lines = {} }
  if not target then
    sel.all = true
    return sel, "all changes"
  end
  if target.kind == "file" then
    sel.files[target.path] = true
    return sel, "file " .. target.path
  end

  local line_indices = target_lines(target, visual, true)
  if #line_indices == 0 then return nil end
  local selected = {}
  for _, i in ipairs(line_indices) do
    selected[i] = true
  end
  sel.lines[target.path] = { [target.hunk_index] = selected }
  return sel, ("%d line(s)"):format(#line_indices)
end

function M.toggle(visual)
  local view = current_view()
  if not view then return end
  use_selection_of(view)

  local target = cursor_target(view, visual)
  if not target then return end
  if target.kind == "file" then
    toggle_file(target.path)
  else
    toggle_lines(target.path, target.hunk_index, target_lines(target, visual, false))
  end
  highlight_selection(view)
end

function M.move_to_index(visual)
  local view = current_view()
  if not view then return end
  use_selection_of(view)

  local root = require("neogit.lib.git").repo.worktree_root
  local sha = view.commit_info.oid
  local short_sha = sha:sub(1, 8)

  local _, parents = git(root, { "rev-list", "--parents", "-n1", sha }) -- "<sha> <parent>..."
  parents = vim.split(parents, " ")
  if #parents > 2 then return notify_error("Merge commits are not supported") end
  local _, head = git(root, { "rev-parse", "HEAD" })
  local problem = repo_problem(root, sha, head)
  if problem then return notify_error(problem) end

  local sel, description
  if is_empty(selection) then
    sel, description = selection_from_cursor(view, visual)
    if not sel then return notify_error("No changed lines selected") end
  else
    local file_count, line_count = count_selected(selection)
    sel, description = selection, ("%d file(s) + %d line(s)"):format(file_count, line_count)
  end

  local patch, err = build_patch(view, root, sel)
  if not patch or vim.trim(patch) == "" then return notify_error("Could not build patch", err) end
  local question = ("Move %s out of %s into the index?"):format(description, short_sha)
  if vim.fn.confirm(question, "&Yes\n&No", 2) ~= 1 then return end

  -- Kept in the git dir rather than a tempfile, so it survives quitting nvim if something fails.
  local _, git_dir = git(root, { "rev-parse", "--absolute-git-dir" })
  local patch_file = git_dir .. "/neogit-move-to-index.patch"
  vim.fn.writefile(vim.split(patch, "\n", { plain = true }), patch_file, "b")

  local ok, message
  if sha == head then
    ok, message, err = move_out_of_head(root, patch_file)
  else
    ok, message, err = move_out_of_older_commit(root, patch_file, sha, parents[2])
  end
  require("neogit").dispatch_refresh()
  if not ok then return notify_error(message .. "\nPatch: " .. patch_file, err) end

  vim.fn.delete(patch_file)
  reset_selection(nil)
  view:close()
  vim.notify(("Moved %s out of %s into the index"):format(description, short_sha), vim.log.levels.INFO, {
    title = "Neogit",
  })
end

function M.clear()
  reset_selection(nil)
  M.highlight()
end

function M.highlight()
  local view = current_view()
  if view then highlight_selection(view) end
end

return M
