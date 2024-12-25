---@type LazySpec
return {
  "gbprod/yanky.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "UIEnter",
  opts = {
    highlight = {
      on_put = true,
      on_yank = true,
      timer = 100,
    },
    ring = {
      history_length = 1000,
      storage = "shada",
      sync_with_numbered_registers = true,
      cancel_event = "update",
      ignore_registers = { "_" },
    },
    system_clipboard = {
      sync_with_ring = false,
    },
    picker = {
      telescope = {
        use_default_mappings = false,
        mappings = {
          default = function(prompt_bufnr) return require("yanky.telescope.mapping").put("p")(prompt_bufnr) end,
          i = {
            ["<c-p>"] = function(prompt_bufnr) return require("yanky.telescope.mapping").put("p")(prompt_bufnr) end,
            ["<c-x>"] = function(prompt_bufnr) require("yanky.telescope.mapping").delete()(prompt_bufnr) end,
            ["<c-r>"] = function(prompt_bufnr)
              require("yanky.telescope.mapping").set_register(require("yanky.utils").get_default_register())(
                prompt_bufnr
              )
            end,
          },
          n = {
            p = function(prompt_bufnr) return require("yanky.telescope.mapping").put("p")(prompt_bufnr) end,
            P = function(prompt_bufnr) return require("yanky.telescope.mapping").put("P")(prompt_bufnr) end,
            d = function(prompt_bufnr) require("yanky.telescope.mapping").delete()(prompt_bufnr) end,
            r = function(prompt_bufnr)
              require("yanky.telescope.mapping").set_register(require("yanky.utils").get_default_register())(
                prompt_bufnr
              )
            end,
          },
        },
      },
    },
  },
  keys = {
    { "y", "<Plug>(YankyYank)", desc = "Yank", mode = { "n", "x" } },
    { "p", "<Plug>(YankyPutAfter)", desc = "Put after", mode = { "n", "x" } },
    { "P", "<Plug>(YankyPutBefore)", desc = "Put before", mode = { "n", "x" } },
    { "gp", "<Plug>(YankyGPutAfter)", desc = "gPut after", mode = { "n", "x" } },
    { "gP", "<Plug>(YankyGPutBefore)", desc = "gPut before", mode = { "n", "x" } },
    { "<M-p>", "<Plug>(YankyPreviousEntry)", desc = "Previous yank", mode = "n" },
    { "<M-n>", "<Plug>(YankyNextEntry)", desc = "Next yank", mode = "n" },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indent after linewise", mode = "n" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indent before linewise", mode = "n" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put indent after shift right", mode = "n" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put indent after shift left", mode = "n" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after filter", mode = "n" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before filter", mode = "n" },
  },
  specs = {
    {
      "nvim-telescope/telescope.nvim",
      opts = function() require("telescope").load_extension("yank_history") end,
      specs = {
        "AstroNvim/astrocore",
        opts = {
          mappings = {
            n = {
              ["<Leader>fy"] = {
                function() require("telescope").extensions.yank_history.yank_history() end,
                desc = "Yank history",
              },
            },
          },
        },
      },
    },
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = {
        highlights = {
          init = {
            YankyYanked = { link = "IncSearch" },
            YankyPut = { link = "IncSearch" },
          },
        },
      },
    },
  },
}
