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
    statuscolumn = { enabled = false },
    picker = {
      prompt = " ",
      layouts = {
        custom_ivy_split = (function()
          local custom_ivy_split = vim.deepcopy(require("snacks.picker.config.layouts").ivy_split)
          custom_ivy_split.layout[1].border = "rounded" -- input field with rounded border
          custom_ivy_split.layout.height = 0.5 -- list area +0.1
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
        maps.n["<Leader>h"] = false
        maps.n["<Leader>un"] = { function() require("snacks").notifier.hide() end, desc = "Dismiss all notifications" }
        maps.n["<Leader>fN"] =
          { function() require("snacks").notifier.show_history() end, desc = "Notifications buffer" }
        maps.n["<Leader>fn"] = {
          function() require("snacks").picker.notifications { confirm = "focus_preview" } end,
          desc = "Notifications",
        }
        maps.n["<Leader>fP"] = {
          function() require("snacks").picker.grep { ft = { "lua", "vim" }, cwd = vim.fn.stdpath("data") .. "/lazy" } end,
          desc = "Words in plugins",
        }
        maps.n["<Leader>Nw"] = {
          function()
            require("snacks").picker.grep {
              ft = "md",
              cwd = vim.env.HOME .. "/Obsidian/vault",
            }
          end,
          desc = "Words in notes",
        }
        maps.n["<Leader>Nf"] = {
          function() require("snacks").picker.files { ft = "md", cwd = vim.env.HOME .. "/Obsidian/vault" } end,
          desc = "Notes",
        }
        maps.x["<Leader>fw"] = {
          function() require("snacks").picker.grep_word() end,
          desc = "Words within selection",
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
          function() require("snacks").picker.files { ft = { "lua", "vim" }, cwd = vim.fn.stdpath("data") .. "/lazy" } end,
          desc = "Plugins",
        }
        maps.n["<Leader>fS"] = {
          function() require("snacks").picker.spelling() end,
          desc = "Spelling",
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
        maps.n["<Leader>R"] = { function() require("snacks").rename.rename_file() end, desc = "Rename current file" }
        maps.n["]r"] = { function() require("snacks").words.jump(vim.v.count1) end, desc = "Next reference" }
        maps.n["[r"] = { function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev reference" }
      end,
    },
    {
      "AstroNvim/astrolsp",
      ---@param opts AstroLSPOpts
      opts = function(_, opts)
        if opts.mappings == nil then opts.mappings = { n = {} } end
        local maps = opts.mappings ---@cast maps -nil
        maps.n["<Leader>lG"] =
          { function() require("snacks").picker.lsp_workspace_symbols() end, desc = "Search workspace symbols" }
      end,
    },
  },
}
