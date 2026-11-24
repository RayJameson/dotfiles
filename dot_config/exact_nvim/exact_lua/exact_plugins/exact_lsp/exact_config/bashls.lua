---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      bashls = {
        settings = {
          bashIde = {
            shellcheckArguments = "-e SC2034",
          },
        },
      },
    },
  },
  specs = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    optional = true,
    opts = {
      ensure_installed = { { "bash-language-server", condition = function() return vim.fn.executable("npm") == 1 end } },
    },
  },
}
