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
      opts_extend = { "commands" },
      opts = {
        commands = {
          {
            name = "Enable hijack for / and ? [eregex.vim]",
            execute = function() vim.api.nvim_call_function("eregex#toggle", {}) end,
          },
        },
      },
    },
  },
}
