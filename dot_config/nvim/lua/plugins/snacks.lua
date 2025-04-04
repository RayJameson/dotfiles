---@diagnostic disable: missing-fields
---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 10000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = {},
    quickfile = {},
    words = {},
    notifier = {},
    statuscolumn = {},
    picker = {
      layouts = {
        custom_ivy_split = (function()
          local custom_ivy_split = vim.deepcopy(require("snacks.picker.config.layouts").ivy_split)
          custom_ivy_split.layout[1].border = "rounded" -- input field with rounded border
          custom_ivy_split.layout.height = 0.5  -- list area +0.1
          return custom_ivy_split
        end)(),
      },
      layout = { preset = function(source) return source == "select" and "select" or "custom_ivy_split" end },
    },
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
  }, --[[@as snacks.plugins.Config]]
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

        opts.autocmds.Snacks = {
          {
            event = "User",
            pattern = "VeryLazy",
            callback = function()
              -- Setup some globals for debugging (lazy-loaded)
              _G.dd = function(...) require("snacks").debug.inspect(...) end
              _G.bt = function() require("snacks").debug.backtrace() end
              vim.print = _G.dd -- Override print to use snacks for `:=` command
            end,
          },
          {
            event = "User",
            pattern = "OilActionsPost",
            callback = function(event)
              if event.data.actions.type == "move" then
                require("snacks").rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
              end
            end,
          },
        }
        maps.n["<Leader>un"] = { function() require("snacks").notifier.hide() end, desc = "Dismiss all notifications" }
        maps.n["<Leader>fn"] = { function() require("snacks").notifier.show_history() end, desc = "Notifications" }
        maps.n["<Leader>fP"] = {
          function()
            require("snacks").picker.grep { ft = { "lua", "vim" }, dirs = { vim.fn.stdpath("data") .. "/lazy" } }
          end,
          desc = "Words in plugins",
        }
        maps.n["<Leader>f/"] = {
          function() require("snacks").picker.grep { glob = vim.fn.expand("%:t"), dirs = { vim.fn.expand("%:h") } } end,
          desc = "Words in current buf",
        }
        maps.n["<Leader>fz"] = {
          function() require("snacks").picker.zoxide() end,
          desc = "Zoxide",
        }
        maps.n["<Leader>fp"] = {
          function()
            require("snacks").picker.files { ft = { "lua", "vim" }, dirs = { vim.fn.stdpath("data") .. "/lazy" } }
          end,
          desc = "Plugins",
        }
        maps.n["<Leader>fu"] = {
          function() require("snacks").picker.undo { layout = "left" } end,
          desc = "Undo",
        }
        maps.n["<Leader>fH"] = {
          function() require("snacks").picker.highlights { confirm = { "yank", "close" }, layout = "default" } end,
          desc = "Highlights",
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
