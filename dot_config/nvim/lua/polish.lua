local function escape(str)
  -- You need to escape these characters to work correctly
  local escape_chars = [[;,."|\]]
  return vim.fn.escape(str, escape_chars)
end

-- Recommended to use lua template string
local en = [[`qwertyuiop[]asdfghjkl;'zxcvbnm]]
local ru = [[ёйцукенгшщзхъфывапролджэячсмить]]
local en_shift = [[~QWERTYUIOP{}ASDFGHJKL:"ZXCVBNM<>]]
local ru_shift = [[ËЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ]]

vim.opt.langmap = vim.fn.join({
  -- | `to` should be first     | `from` should be second
  escape(ru_shift)
    .. ";"
    .. escape(en_shift),
  escape(ru) .. ";" .. escape(en),
}, ",")

-----------------------------------------------------------------------------//
-- Multiple Cursor Replacement
-- http://www.kevinli.co/posts/2017-01-19-multiple-cursors-in-500-bytes-of-vimscript/
-----------------------------------------------------------------------------//

-- In Normal mode:
-- 1. Position the cursor anywhere in the word.
-- 2. Hit `cn`, type word for replacement, then go back to Normal mode.
-- 3. Hit `.` n-1 times, where n is the number of replacements.
-- 4. Hit `<Enter>` to repeat the macro over search matches.

-- Sometimes, the target to change is not a whole word.
-- In these cases, we would first manually select the word (using appropriate motions and text objects) and then issue `cn`.
-- 1. Select part of the word in visual mode.
-- 2. Hit `cn` to start the replacement process.
-- 3. Enter word for replacement, then hit `.` an appropriate number of times.
-- 4. Use `n` to skip over the matches.

-- Over search matches:
-- 1. Position the cursor over a word; alternatively, make a selection.
-- 2. Hit `cq` to start recording the macro.
-- 3. Once you are done with the macro, go back to normal mode.
-- 4. Hit `<Enter>` to repeat the macro over search matches.

vim.cmd([[
  let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

  nnoremap cn *``"_cgn
  nnoremap cN *``"_cgN

  vnoremap <expr> cn g:mc . "``cgn"
  vnoremap <expr> cN g:mc . "``cgN"

  function! SetupCR()
    nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
  endfunction

  nnoremap cq :call SetupCR()<CR>*``qz
  nnoremap cQ :call SetupCR()<CR>#``qz

  vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"
  vnoremap <expr> cQ ":\<C-u>call SetupCR()\<CR>" . "gv" . substitute(g:mc, '/', '?', 'g') . "``qz"
]])

-- Set up custom filetypes
vim.filetype.add {
  filename = {
    ["poetry.lock"] = "toml",
    ["%.?zshrc"] = "zsh",
  },
  extension = {
    tlua = "lua",
    rasi = "rasi",
  },
  pattern = {
    -- ["~/%.config/foo/.*"] = "fooscript",
    ["%.gitconfig.*"] = "gitconfig",
    [".*/%.vscode/.+%.json"] = "jsonc",
    [".*/i3/config%.d/.+%.conf"] = "i3config",
    [".*/hypr/**/.+%.conf"] = "hyprlang",
    [".*/uwsm/env"] = "sh",
  },
}

local better_luafile = require("better_luafile")
vim.api.nvim_create_user_command(
  "BetterLuafile",
  function(opts) better_luafile.call(opts.fargs, "horizontal", 15, true) end,
  { nargs = "?" }
)

if vim.g.neovide then
  local copy_shortcuts = { "<C-S-C>" }
  local paste_shortcuts = { "<C-S-V>" }
  if jit.os == "OSX" then
    table.insert(copy_shortcuts, "<D-c>")
    table.insert(paste_shortcuts, "<D-v>")
    vim.g.neovide_input_macos_option_key_is_meta = "both"
    vim.o.guifont = "Iosevka Nerd Font Mono Condensed ExtraLight:h24.5:#h-none"
  else
    vim.o.guifont = "Iosevka Nerd Font Mono Condensed ExtraLight:h19:#h-none"
  end
  for _, paste_shortcut in ipairs(paste_shortcuts) do
    for _, mode in ipairs { "n", "i", "x", "v", "t", "c" } do
      vim.keymap.set(
        mode,
        paste_shortcut,
        function() vim.api.nvim_paste(vim.fn.getreg("+"), true, -1) end,
        { desc = "Paste from system clipboard" }
      )
    end
  end
  for _, copy_shortcut in ipairs(copy_shortcuts) do
    vim.keymap.set("x", copy_shortcut, '"+y', { desc = "Copy to system clipboard" })
  end
  vim.g.neovide_cursor_antialiasing = true
  vim.o.linespace = -1
  vim.g.neovide_floating_blur_amount_x = 2.0
  vim.g.neovide_floating_blur_amount_y = 2.0
  vim.g.neovide_refresh_rate_idle = 5
  vim.g.neovide_floating_shadow = false
end

vim.tbl_map(function(v) vim.api.nvim_del_keymap("n", "gr" .. v) end, { "r", "a", "n", "i" })
