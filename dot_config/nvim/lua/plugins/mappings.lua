---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(
    _,
    opts --[[@as AstroCoreOpts]]
  )
    local maps = opts.mappings
    local is_available = require("astrocore").is_available
    -- disable defaults:
    if maps.n["<Leader>fo"] then maps.n["<Leader>fo"].desc = "Recent files" end
    maps.n["<Leader>b"] = false
    for _, char in ipairs { "b", "d", "C", "c", "l", "r", "s", "p", "\\", "|" } do
      maps.n["<Leader>b" .. char] = false
      if char == "s" then
        for _, s_char in ipairs { "e", "i", "m", "p", "r" } do
          maps.n["<Leader>bs" .. s_char] = false
        end
      end
    end
    --]

    --[ jumplist for j/k number jumps
    maps.n["k"] = { "(v:count > 1 ? \"m'\" . v:count : '') . 'k'", silent = true, expr = true }
    maps.n["j"] = { "(v:count > 1 ? \"m'\" . v:count : '') . 'j'", silent = true, expr = true }
    --]

    --[ register + clipboard
    for _, mode in ipairs { "n", "x" } do
      maps[mode]["gy"] = { '"+y', desc = "yank +clipboard" }
      maps[mode]["gY"] = { '"+y$', desc = "Yank +clipboard (y$)" }
    end
    maps.n["gD"] = { '"_d', desc = "Delete noregister" }
    maps.x["gd"] = { '"_d', desc = "Delete noregister" }
    maps.x["gp"] = { "P", desc = "Paste noregister" }
    maps.n["S"] = { "0Di", desc = "S+" }
    --]

    -- Repeat macros across visual selection
    maps.x["@"] = {
      function() return ":norm @" .. vim.fn.getcharstr() .. "<cr>" end,
      desc = "Repeat macros across visual selection",
      silent = false,
      expr = true,
    }

    --[ command window
    maps.n["q:"] = { "q:i", desc = "Command window" }
    maps.n["q/"] = { "q/i", desc = "Command search down window" }
    maps.n["q?"] = { "q?i", desc = "Command search up window" }
    --]

    maps.n["<Leader>,"] = {
      function()
        if vim.bo[vim.api.nvim_get_current_buf()].filetype == "oil" then
          require("oil.actions").cd.callback { scope = "win", silent = true }
          local dir = require("oil").get_current_dir(0)
          vim.notify(string.format("Win CWD: %s", dir), vim.log.levels.INFO)
        else
          vim.cmd.lcd { args = { "%:p:h" } }
          vim.notify(string.format("Win CWD: %s", vim.fn.expand("%:p:h")), vim.log.levels.INFO)
        end
      end,
      desc = "lcd to current file's dir",
    }
    maps.n["<Leader>."] = {
      function()
        if vim.bo[vim.api.nvim_get_current_buf()].filetype == "oil" then
          require("oil.actions").cd.callback { scope = "tab", silent = true }
          local dir = require("oil").get_current_dir(0)
          vim.notify(string.format("Tab CWD: %s", dir), vim.log.levels.INFO)
        else
          vim.cmd.tcd { args = { "%:p:h" } }
          vim.notify(string.format("Tab CWD: %s", vim.fn.expand("%:p:h")), vim.log.levels.INFO)
        end
      end,
      desc = "tcd to current file's dir",
    }
    maps.n["<Leader>F"] = {
      ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/g<Left><Left>",
      desc = "Find and replace",
    }
    maps.x["<Leader>F"] = {
      '<Esc>"fyiw<CR>gv:s/<C-r>f/<C-r>f/g<Left><Left>',
      desc = "Find and replace visual",
    }
    maps.n["<C-d>"] = { "<C-d>M", desc = "Scroll half page down", noremap = true }
    maps.n["<C-u>"] = { "<C-u>M", desc = "Scroll half page up", noremap = true }
    maps.n["<C-f>"] = { "<C-f>M", desc = "Scroll page down", noremap = true }
    maps.n["<C-b>"] = { "<C-b>M", desc = "Scroll page up", noremap = true }
    maps.n["<M-l>"] = { "10zl", desc = "Scroll horizontally right", noremap = true }
    maps.n["<M-h>"] = { "10zh", desc = "Scroll horizontally left", noremap = true }
    maps.n["[b"] = { "<Cmd>bprev<CR>", desc = "Previous buffer" }
    maps.n["]b"] = { "<Cmd>bnext<CR>", desc = "Next buffer" }
    maps.x["<"] = { "<gv", desc = "Deindent line" }
    maps.x[">"] = { ">gv", desc = "Indent line" }

    --[ Better ^ and $
    maps.n["gh"] = { "^", desc = "go to beginning of the line (^)" }
    maps.n["gl"] = { "$", desc = "go to end of the line ($)" }
    maps.x["gh"] = { "^", desc = "go to beginning of the line (^)" }
    maps.x["gl"] = { "$", desc = "go to end of the line ($)" }
    --]

    maps.n["<Leader>C"] = {
      "<Cmd>%bdelete!|edit#<Cr>",
      desc = "Close all other buffers",
    }
    maps.n["<Leader>a"] = {
      "<Cmd>%bdelete!<Cr>",
      desc = "Close all buffers",
    }
    maps.n["<Leader>c"] = {
      function()
        require("astrocore.buffer").close()
        local bufs = vim.fn.getbufinfo { buflisted = true }
        if is_available("alpha-nvim") and not bufs[2] then
          require("alpha").start(false, require("alpha").default_config)
        end
      end,
      desc = "Close current buffer",
    }

    --]
    local function ui_notify(str)
      if vim.g.ui_notifications_enabled then require("astrocore").notify(str) end
    end

    local function bool2str(bool) return bool and "on" or "off" end

    local function toggle_lazyreadraw()
      vim.opt.lazyredraw = not vim.opt.lazyredraw:get()
      ui_notify(("lazy redraw %s"):format(bool2str(vim.opt.lazyredraw:get())))
    end

    maps.n["<Leader>N"] = { desc = " Notes" }
    maps.n["<Leader>Nn"] = {
      function()
        vim.ui.input({ prompt = "Enter note name, use / for directories" }, function(input)
          if input == nil then return end
          local note_path = vim.fn.fnameescape(input)
          vim.cmd.edit(vim.env.HOME .. "/Obsidian/vault/" .. note_path .. ".md")
        end)
      end,
      desc = "New note",
    }
    maps.n["<Leader>ur"] = { toggle_lazyreadraw, desc = "Toggle lazyredraw" }

    maps.n["<Leader>rn"] = { "<CMD>BetterLuafile<CR>", desc = "Run lua file with nvim-lua" }

    -- Move Lines
    maps.n["<CR>"] = { "o<Esc>k", desc = "Put empty line below" }
    maps.n["<S-CR>"] = { "O<Esc>j", desc = "Put empty line above" }
    maps.n["<M-j>"] = { "<cmd>m .+1<cr>==", desc = "Move down" }
    maps.n["<M-k>"] = { "<cmd>m .-2<cr>==", desc = "Move up" }
    maps.i["<M-j>"] = { "<esc><cmd>m .+1<cr>==gi", desc = "Move down" }
    maps.i["<M-k>"] = { "<esc><cmd>m .-2<cr>==gi", desc = "Move up" }
    maps.x["<M-j>"] = { ":m '>+1<cr>gv=gv", desc = "Move down" }
    maps.x["<M-k>"] = { ":m '<-2<cr>gv=gv", desc = "Move up" }
    maps.t["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Enter Normal Mode" }
    -- Smart Splits (remapped on Meta key)
    if is_available("smart-splits.nvim") then
      -- Resize with arrows
      maps.n["<M-Up>"] = { function() require("smart-splits").resize_up() end, desc = "Resize split up" }
      maps.n["<M-Down>"] = { function() require("smart-splits").resize_down() end, desc = "Resize split down" }
      maps.n["<M-Left>"] = { function() require("smart-splits").resize_left() end, desc = "Resize split left" }
      maps.n["<M-Right>"] = { function() require("smart-splits").resize_right() end, desc = "Resize split right" }
    else
      maps.n["<M-Up>"] = { "<CMD>resize -2<CR>", desc = "Resize split up" }
      maps.n["<M-Down>"] = { "<CMD>resize +2<CR>", desc = "Resize split down" }
      maps.n["<M-Left>"] = { "<CMD>vertical resize -2<CR>", desc = "Resize split left" }
      maps.n["<M-Right>"] = { "<CMD>vertical resize +2<CR>", desc = "Resize split right" }
    end

    -- add more text objects for "in" and "around"
    for _, mode in ipairs { "x", "o" } do
      for _, char in ipairs { "_", ".", ":", ",", ";", "|", "/", "\\", "*", "+", "%", "`", "?" } do
        maps[mode]["i" .. char] = {
          string.format(":<C-u>silent! normal! f%sF%slvt%s<CR>", char, char, char),
          desc = "inside " .. char,
        }
        maps[mode]["a" .. char] = {
          string.format(":<C-u>silent! normal! f%sF%svf%s<CR>", char, char, char),
          desc = "around " .. char,
        }
      end
    end
    for k in string.gmatch("AaBbCcDdFfEeGgHIiJjhKkLlMmNnOoPpQqRrSsTtUuWwXxYyZz'./", ".") do
      local mapping = maps.n["<Leader>f" .. k]
      if mapping then
        local prefix = "Find "
        if vim.startswith(mapping.desc, prefix) then
          assert(type(mapping.desc) == "string")
          mapping.desc = mapping.desc:sub(#prefix + 1)
          mapping.desc = mapping.desc:sub(1, 1):upper() .. mapping.desc:sub(2)
        end
      end
    end
  end,
}
