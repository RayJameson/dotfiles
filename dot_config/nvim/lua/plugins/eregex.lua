---@type LazySpec
return {
  "othree/eregex.vim",
  lazy = false,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            eregex_default_enable = false,
          },
        },
      },
    },
    {
      "DanWlker/toolbox.nvim",
      opts = {
        commands = {
          {
            name = "Enable `eregex.vim` hijack for / and ?",
            execute = function() vim.api.nvim_call_function("eregex#toggle", {}) end,
          },
        },
      },
    },
  },
}
