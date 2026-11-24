---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(
    _,
    opts --[[@as AstroCoreOpts]]
  )
    local maps = opts.mappings
    -- disable defaults:
    if maps.n["<Leader>fo"] then maps.n["<Leader>fo"].desc = "Recent files" end
    maps.n["<Leader>b"] = false
    maps.i["<D-Space>"] = { "<Nop>", noremap = true, silent = true }
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
    maps.n["k"] = { [[(v:count > 1 ? "m'" . v:count : 'g') . 'k']], silent = true, expr = true }
    maps.n["j"] = { [[(v:count > 1 ? "m'" . v:count : 'g') . 'j']], silent = true, expr = true }
    --]

    --[ register + clipboard
    for _, mode in ipairs { "n", "x" } do
      maps[mode]["gy"] = { '"+y', desc = "yank +clipboard" }
      maps[mode]["gY"] = { '"+y$', desc = "Yank +clipboard (y$)" }
    end
    maps.n["gD"] = { '"_d', desc = "Delete noregister" }
    maps.x["gD"] = { '"_d', desc = "Delete noregister" }
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

    maps.x["/"] = { "<Esc>/\\%V", desc = "search within visual selection" }

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
    maps.n["<Leader>rn"] = { "<CMD>BetterLuafile<CR>", desc = "Run lua file with nvim-lua" }

    -- Move Lines
    maps.n["<M-j>"] = { "<cmd>m .+1<cr>==", desc = "Move down" }
    maps.n["<M-k>"] = { "<cmd>m .-2<cr>==", desc = "Move up" }
    maps.i["<M-j>"] = { "<esc><cmd>m .+1<cr>==gi", desc = "Move down" }
    maps.i["<M-k>"] = { "<esc><cmd>m .-2<cr>==gi", desc = "Move up" }
    maps.x["<M-j>"] = { ":m '>+1<cr>gv=gv", desc = "Move down" }
    maps.x["<M-k>"] = { ":m '<-2<cr>gv=gv", desc = "Move up" }
    maps.t["<Esc><Esc>"] = { "<C-\\><C-n>", desc = "Enter Normal Mode" }

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
