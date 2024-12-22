---@diagnostic disable: missing-fields
---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  ---@param opts snacks.Config
  opts = function(_, opts)
    local astrocore = require("astrocore")
    return astrocore.extend_tbl(opts, {
      input = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = false },
      words = { enabled = true },
      bigfile = { enabled = false },
      notifier = {
        enabled = not astrocore.is_available("nvim-notify"),
        timeout = 3000,
      },
      win = {
        border = "rounded",
        backdrop = false,
      },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find files", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New file", action = ":ene | startinsert" },
            { icon = " ", key = "w", desc = "Find words", action = ":lua Snacks.dashboard.pick('live_grep')" },
            {
              icon = " ",
              key = "z",
              desc = "Find directories zoxide",
              action = ":Telescope zoxide list",
              enabled = function() return pcall(require, "telescope._extensions.zoxide") end,
            },
            { icon = " ", key = "r", desc = "Recent files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            {
              icon = " ",
              key = "c",
              desc = "Config",
              action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
            },
            { icon = " ", key = "s", desc = "Restore last session", section = "session" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent files", section = "recent_files", indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
        },
      },
      styles = {
        notification = {
          wo = { wrap = true }, -- Wrap notifications
        },
      },
      scratch = {
        win = {
          keys = {
            source = {
              "<CR>",
              function(self)
                if vim.bo[self.buf].filetype == "lua" then
                  local name = "scratch." .. vim.fn.fnamemodify(vim.api.nvim_buf_get_name(self.buf), ":e")
                  require("snacks").debug.run { buf = self.buf, name = name }
                else
                  vim.cmd([[OverseerRun file-run]])
                end
              end,
              desc = "Run code",
              mode = { "n", "x" },
            },
          },
        },
      },
    } --[[@as snacks.plugins.Config]])
  end,
  specs = {
    { "rcarriga/nvim-notify", enabled = false },
    { "RRethy/vim-illuminate", enabled = false },
    {
      "rebelot/heirline.nvim",
      optional = true,
      opts = function(_, opts)
        if vim.tbl_get(require("astrocore").plugin_opts("snacks.nvim"), "statuscolumn", "enabled") then
          opts.statuscolumn = false
        end
      end,
    },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings

        opts.autocmds.snacks_toggle = {
          event = "User",
          pattern = "VeryLazy",
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...) require("snacks").debug.inspect(...) end
            _G.bt = function() require("snacks").debug.backtrace() end
            vim.print = _G.dd -- Override print to use snacks for `:=` command
          end,
        }
        maps.n["<Leader>un"] = { function() require("snacks").notifier.hide() end, desc = "Dismiss all notifications" }
        maps.n["<Leader>fn"] = { function() require("snacks").notifier.show_history() end, desc = "Notifications" }
        maps.n["<Leader>c"] = { function() require("snacks").bufdelete.delete() end, desc = "Delete current buffer" }
        maps.n["<Leader>a"] = { function() require("snacks").bufdelete.all() end, desc = "Delete all buffers" }
        maps.n["<Leader>C"] = { function() require("snacks").bufdelete.other() end, desc = "Delete all other buffers" }
        maps.n["<Leader>rb"] = {
          function()
            require("snacks").scratch.open { ft = vim.bo[vim.api.nvim_get_current_buf()].filetype, template = "" }
          end,
          desc = "Open scratch buffer with current ft",
        }
        maps.n["<Leader>rl"] = {
          function() require("snacks").scratch.select() end,
          desc = "Select scratch buffer",
        }
        maps.n["<Leader>R"] = { function() require("snacks").rename.rename_file() end, desc = "Rename current file" }
        maps.n["]r"] = { function() require("snacks").words.jump(vim.v.count1) end, desc = "Next reference" }
        maps.n["[r"] = { function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev reference" }
      end,
    },
  },
}
