---@type LazySpec
return {
  "folke/lazydev.nvim",
  optional = true,
  specs = { "justinsgithub/wezterm-types", lazy = true },
  opts_extend = { "library" },
  opts = {
    library = {
      { path = "wezterm-types/types", mods = { "wezterm" } },
    },
  },
}
