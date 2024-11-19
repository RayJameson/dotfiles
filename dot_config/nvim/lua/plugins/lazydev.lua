---@type LazySpec
return {
  "folke/lazydev.nvim",
  optional = true,
  specs = { "justinsgithub/wezterm-types", lazy = true },
  opts = {
    library = {
      { path = "wezterm-types/types", mods = { "wezterm" } },
    },
  },
}
