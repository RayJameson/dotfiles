---@type LazySpec
return {
  "Exafunction/codeium.vim",
  event = "LspAttach",
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            codeium_enabled = false,
          },
        },
        mappings = {
          i = {
            ["<C-g>"] = {
              function() return vim.api.nvim_call_function("codeium#Accept", {}) end,
              desc = "Codeium accept",
              expr = true,
            },
            ["<C-,"] = {
              function() return vim.api.nvim_call_function("codeium#CycleCompletions", { 1 }) end,
              desc = "Codeium next",
              expr = true,
            },
            ["<C-x>"] = {
              function() return vim.api.nvim_call_function("codeium#Clear", {}) end,
              desc = "Codeium clear",
              expr = true,
            },
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
            name = "Enable AI suggestions [codeium.vim]",
            execute = "CodeiumToggle",
          },
        },
      },
    },
  },
}
