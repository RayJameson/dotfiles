---@type LazySpec
return {
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      auto_refresh = false,
      keys = {
        ["<ESC>"] = "close",
        ["q"] = "close",
        ["<C-E>"] = "close",
      },
      win = { wo = { colorcolumn = "" } },
      preview = {
        scratch = false,
      },
      modes = {
        lsp_references = {
          params = {
            include_declaration = false,
          },
        },
      },
    },
    specs = {
      { "AstroNvim/astroui", opts = { icons = { Trouble = "󱍼" } } },
      {
        "AstroNvim/astrolsp",
        opts = function(
          _,
          opts --[[@as AstroLSPOpts]]
        )
          local maps = opts.mappings
          maps.n.gr = {
            function() require("trouble").toggle { mode = "lsp_references", focus = true, auto_jump = true } end,
            desc = "LSP references [T]",
          }
          maps.n.go = {
            function() require("trouble").toggle { mode = "lsp_incoming_calls", focus = true, auto_jump = true } end,
            desc = "LSP incoming calls [T]",
          }
          maps.n.gO = {
            function() require("trouble").toggle { mode = "lsp_outgoing_calls", focus = true, auto_jump = true } end,
            desc = "LSP outgoing calls [T]",
          }
          maps.n["<Leader>li"] = {
            function() require("trouble").toggle { mode = "lsp_incoming_calls", focus = true, auto_jump = true } end,
            desc = "LSP incoming calls [T]",
          }
          maps.n["<Leader>lI"] = {
            function() require("trouble").toggle { mode = "lsp_implementations", focus = true, auto_jump = true } end,
            desc = "LSP implementations [T]",
          }
          maps.n["<Leader>lt"] = {
            function() require("trouble").toggle { mode = "lsp_type_definitions", focus = true, auto_jump = true } end,
            desc = "LSP type definitions [T]",
          }
          maps.n["<Leader>lo"] = {
            function() require("trouble").toggle { mode = "lsp_outgoing_calls", focus = true, auto_jump = true } end,
            desc = "LSP outgoing calls [T]",
          }
          maps.n["<Leader>lR"] = {
            function() require("trouble").toggle { mode = "lsp_references", focus = true, auto_jump = true } end,
            desc = "LSP references [T]",
          }
          maps.n.gd = {
            function() require("trouble").toggle { mode = "lsp_definitions", focus = true, auto_jump = true } end,
            desc = "LSP definitions [T]",
          }
          maps.n.gI = {
            function() require("trouble").toggle { mode = "lsp_implementations", focus = true, auto_jump = true } end,
            desc = "LSP implementations [T]",
          }
        end,
      },
      {
        "AstroNvim/astrocore",
        opts = function(
          _,
          opts --[[@as AstroCoreOpts]]
        )
          local maps = opts.mappings
          local prefix = "<Leader>x"
          maps.n[prefix] = { desc = require("astroui").get_icon("Trouble", 1, true) .. "Trouble" }
          maps.n[prefix .. "X"] = {
            function() require("trouble").toggle { mode = "diagnostics", focus = true } end,
            desc = "Workspace Diagnostics [T]",
          }
          maps.n[prefix .. "x"] = {
            function() require("trouble").toggle { mode = "diagnostics", focus = true, filter = { buf = 0 } } end,
            desc = "Document Diagnostics [T]",
          }
          maps.n[prefix .. "L"] = {
            function() require("trouble").toggle { mode = "loclist", focus = true } end,
            desc = "Location List [T]",
          }
          maps.n[prefix .. "Q"] = {
            function() require("trouble").toggle { mode = "quickfix", focus = true } end,
            desc = "Quickfix List [T]",
          }
          if require("astrocore").is_available("todo-comments.nvim") then
            maps.n[prefix .. "t"] = {
              function() require("trouble").toggle { mode = "todo", focus = true, filter = { tag = { "TODO" } } } end,
              desc = "Todo [T]",
            }
            maps.n[prefix .. "T"] = {
              function() require("trouble").toggle { mode = "todo", focus = true } end,
              desc = "All comments [T]",
            }
          end
          opts.autocmds.TroubleView = {
            {
              event = "BufEnter",
              desc = "Jump to first entry in trouble view",
              callback = function(args)
                if vim.bo[args.buf].filetype == "trouble" then
                  local cursor_pos = vim.api.nvim_win_get_cursor(0)
                  ---@diagnostic disable-next-line: missing-parameter
                  if cursor_pos[1] == 1 and cursor_pos[2] == 0 then vim.schedule(function() require("trouble").next() end) end
                end
              end,
            },
          }
          opts.autocmds.TroubleMappings = {
            {
              event = "FileType",
              desc = "Create jump mappings for trouble view",
              pattern = "trouble",
              callback = function()
                maps.n["j"] = {
                  ---@diagnostic disable-next-line: missing-parameter
                  function() require("trouble").next() end,
                  desc = "Jump to next entry",
                }
                maps.n["k"] = {
                  ---@diagnostic disable-next-line: missing-parameter
                  function() require("trouble").prev() end,
                  desc = "Jump to previous entry",
                }
                require("astrocore").set_mappings(maps, { buffer = 0 })
              end,
            },
          }
        end,
      },
      { "lewis6991/gitsigns.nvim", opts = { trouble = true }, optional = true },
      {
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
          if not opts.bottom then opts.bottom = {} end
          table.insert(opts.bottom, "Trouble")
        end,
      },
      {
        "catppuccin",
        optional = true,
        ---@type CatppuccinOptions
        opts = { integrations = { lsp_trouble = true } },
      },
    },
  },
}
