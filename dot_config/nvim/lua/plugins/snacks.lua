---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  ---@param opts snacks.Config
  opts = function(_, opts)
    local astrocore = require("astrocore")
    local Snacks = require("snacks")
    return astrocore.extend_tbl(opts, {
      bigfile = { enabled = not vim.tbl_get(astrocore.config, "autocmds", "large_buf_settings") },
      notifier = {
        enabled = not astrocore.is_available("nvim-notify"),
        timeout = 3000,
      },
      dashboard = {
        enabled = true,
        preset = {
          ---@type snacks.dashboard.Item[]
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
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = not astrocore.is_available("vim-illuminate") },
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
                  Snacks.debug.run { buf = self.buf, name = name }
                else
                  vim.cmd([[<Cmd>OverseerRun file-run<CR>]])
                end
              end,
              desc = "Run code",
              mode = { "n", "x" },
            },
          },
        },
      },
    } --[[ @type snacks.Config ]])
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
  },
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local Snacks = require("snacks")
        local maps = opts.mappings

        opts.autocmds.snacks_toggle = {
          event = "User",
          pattern = "VeryLazy",
          callback = function()
            -- Setup some globals for debugging (lazy-loaded)
            _G.dd = function(...) Snacks.debug.inspect(...) end
            _G.bt = function() Snacks.debug.backtrace() end
            vim.print = _G.dd -- Override print to use snacks for `:=` command

            -- Create some toggle mappings
            Snacks.toggle.option("spell", { name = "Spelling" }):map("<Leader>us")
            Snacks.toggle.option("wrap", { name = "Wrap" }):map("<Leader>uw")
            Snacks.toggle.option("relativenumber", { name = "Relative number" }):map("<Leader>uL")
            Snacks.toggle.diagnostics():map("<Leader>ud")
            Snacks.toggle.line_number():map("<Leader>ul")
            Snacks.toggle
              .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
              :map("<Leader>uc")
            Snacks.toggle.treesitter():map("<Leader>uT")
            Snacks.toggle
              .option("background", { off = "light", on = "dark", name = "Dark background" })
              :map("<Leader>ub")
            Snacks.toggle.inlay_hints():map("<Leader>uh")
          end,
        }
        maps.n["<Leader>un"] = { function() Snacks.notifier.hide() end, desc = "Dismiss all notifications" }
        maps.n["<Leader>fn"] = { function() Snacks.notifier.show_history() end, desc = "Notifications" }
        maps.n["<Leader>c"] = { function() Snacks.bufdelete.delete() end, desc = "Delete current buffer" }
        maps.n["<Leader>a"] = { function() Snacks.bufdelete.all() end, desc = "Delete all buffers" }
        maps.n["<Leader>C"] = { function() Snacks.bufdelete.other() end, desc = "Delete all other buffers" }
        maps.n["<Leader>rb"] = {
          function() Snacks.scratch.open { ft = vim.bo[vim.api.nvim_get_current_buf()].filetype } end,
          desc = "Open scratch buffer with current ft",
        }
        maps.n["<Leader>rl"] = {
          function() Snacks.scratch.select() end,
          desc = "Select scratch buffer",
        }
        maps.n["<Leader>R"] = { function() Snacks.rename.rename_file() end, desc = "Rename current file" }
        maps.n["]r"] = { function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference" }
        maps.n["[r"] = { function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference" }
      end,
    },
  },
}
