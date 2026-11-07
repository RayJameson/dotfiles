---@type LazySpec
return {
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "User AstroFile",
    main = "rainbow-delimiters.setup",
    opts = {},
  },
  {
    "catppuccin",
    optional = true,
    ---@type CatppuccinOptions
    opts = { integrations = { rainbow_delimiters = true } },
  },
}
