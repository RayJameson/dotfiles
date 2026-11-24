---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts_extend = { "servers" },
  opts = { servers = { "gh_actions_ls" } },
  specs = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        { "gh-actions-language-server", condition = function() return vim.fn.executable("npm") == 1 end },
      },
    },
  },
}
