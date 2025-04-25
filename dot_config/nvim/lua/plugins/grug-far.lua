---@type LazySpec
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  specs = {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = { icons = { GrugFar = "󰛔" } },
    },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
        local maps, prefix = opts.mappings, "<Leader>s" ---@cast maps -nil

        maps.n[prefix] = { desc = require("astroui").get_icon("GrugFar", 1, true) .. "Search and Replace" }
        maps.x[prefix] = { desc = require("astroui").get_icon("GrugFar", 1, true) .. "Search and Replace" }

        maps.n[prefix .. "s"] = {
          function() require("grug-far").open { transient = true } end,
          desc = "Default search",
        }
        maps.x[prefix .. "s"] = {
          function()
            require("grug-far").open {
              transient = true,
              startCursorRow = 3,
              visualSelectionUsage = "operate-within-range",
            }
          end,
          desc = "Default search",
        }
        maps.x[prefix .. "m"] = {
          function()
            require("grug-far").open {
              transient = true,
              startCursorRow = 3,
            }
          end,
          desc = "Multiline search",
        }
        maps.n[prefix .. "a"] = {
          function() require("grug-far").open { transient = true, engine = "astgrep" } end,
          desc = "AST search",
        }
        maps.n[prefix .. "b"] = {
          function() require("grug-far").open { transient = true, prefills = { paths = vim.fn.expand("%") } } end,
          desc = "Current buffer",
        }
        maps.x[prefix .. "b"] = {
          function() require("grug-far").open { transient = true, prefills = { paths = vim.fn.expand("%") } } end,
          desc = "Current buffer",
        }
        maps.n[prefix .. "w"] = {
          function()
            require("grug-far").open {
              transient = true,
              prefills = { search = vim.fn.expand("<cword>") },
              startCursorRow = 3,
            }
          end,
          desc = "Current word",
        }
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      optional = true,
      opts = {
        filetypes = {
          ["grug-far"] = false,
          ["grug-far-history"] = false,
        },
      },
    },
    {
      "catppuccin",
      optional = true,
      ---@type CatppuccinOptions
      opts = { integrations = { grug_far = true } },
    },
  },
  ---@param opts GrugFarOptionsOverride
  opts = function(_, opts)
    if not opts.icons then opts.icons = {} end
    opts.icons.enabled = vim.g.icons_enabled
    if not vim.g.icons_enabled then
      opts.resultsSeparatorLineChar = "-"
      opts.spinnerStates = {
        "⠋",
        "⠙",
        "⠹",
        "⠸",
        "⠼",
        "⠴",
        "⠦",
        "⠧",
        "⠇",
        "⠏",
      }
    end
  end,
}
