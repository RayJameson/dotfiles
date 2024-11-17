---@type LazySpec
return {
  "chrisgrieser/nvim-scissors",
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
              local scissors = require("scissors")
              local _, err = pcall(scissors.editSnippet)
              if err ~= nil then
                if err:find("json could not be read") ~= nil then scissors.addNewSnippet() end
              end
            end,
          },
          {
            name = "Create new snippet [scissors.nvim]",
            execute = function() require("scissors").addNewSnippet() end,
          },
        },
      },
    },
  },
}
