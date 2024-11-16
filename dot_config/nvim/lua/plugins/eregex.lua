---@type LazySpec
return {
  "othree/eregex.vim",
  lazy = false,
  specs = {
    "AstroNvim/astrocore",
    opts = {
      options = {
        g = {
          eregex_default_enable = false,
        },
      },
    },
  },
}
