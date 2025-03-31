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
      input = {},
      quickfile = {},
      words = {},
      notifier = {},
      statuscolumn = {},
      image = { doc = { enabled = true } },
      dashboard = { enabled = false },
      indent = { indent = { char = "│" }, scope = { char = "│" } },
      bigfile = { enabled = false },
      win = {
        border = "rounded",
        backdrop = false,
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
        maps.n["<Leader>fP"] = {
          function()
            require("snacks").picker.grep { ft = { "lua", "vim" }, dirs = { vim.fn.stdpath("data") .. "/lazy" } }
          end,
          desc = "Words in plugins",
        }
        maps.n["<Leader>fp"] = {
          function()
            require("snacks").picker.files { ft = { "lua", "vim" }, dirs = { vim.fn.stdpath("data") .. "/lazy" } }
          end,
          desc = "Plugins",
        }
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
