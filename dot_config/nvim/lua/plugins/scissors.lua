---@type LazySpec
return {
  "chrisgrieser/nvim-scissors",
  lazy = true,
  dependencies = "nvim-telescope/telescope.nvim",
  opts = {
    snippetDir = vim.fn.stdpath("config") .. "/snippets",
    jsonFormatter = vim.fn.executable("jq") == 1 and "jq" or "none",
  },
  specs = {
    {
      "DanWlker/toolbox.nvim",
      opts_extend = { "commands" },
      opts = {
        commands = {
          {
            name = "Edit snippet [scissors.nvim]",
            execute = function()
              require("scissors").editSnippet()
            end,
          },
          {
            name = "Create new snippet [scissors.nvim]",
            execute = function()
              require("scissors").addNewSnippet()
            end,
          },
        },
      },
    },
  },
}
