-- customize mason plugins
-- tools are installed by the plugin/LSP files that use them, and by community packs (lua, go, docker, json, yaml, ...)
---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        { "vim-language-server", condition = function() return vim.fn.executable("npm") == 1 end },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        height = 0.8,
        backdrop = 100,
      },
    },
  },
}
