---@type LazySpec
return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "User AstroFile",
    main = "rainbow-delimiters.setup",
    opts = {},
    specs = {
      "folke/snacks.nvim",
      optional = true,
      opts = function()
        require("snacks.toggle")
          .new({
            name = "rainbow delimiters (buffer)",
            get = function() return require("rainbow-delimiters").is_enabled(vim.api.nvim_get_current_buf()) end,
            set = function() require("rainbow-delimiters").toggle(vim.api.nvim_get_current_buf()) end,
          })
          :map("<Leader>u(")
      end,
    },
  },
  {
    "catppuccin",
    optional = true,
    ---@type CatppuccinOptions
    opts = { integrations = { rainbow_delimiters = true } },
  },
}
