---@type LazySpec
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      python = { "pyink" },
      -- never fall back to lua_ls formatting (conform ignores `filter` in default_format_opts)
      lua = { "stylua", lsp_format = "never" },
    },
    formatters = {
      pyink = { prepend_args = { "--line-length", "120" } },
    },
  },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        opts.options.g.autoformat = false -- conform.nvim format on save
        local maps = opts.mappings
        -- <Leader>uf/<Leader>uF are the snacks toggles below
        maps.n["<Leader>uf"] = false
        maps.n["<Leader>uF"] = false
        -- :Format formats whole lines; conform's own visual range drops the last char and stylua skips that line
        maps.v["<Leader>lf"] = { ":Format<CR>", desc = "Format selection", silent = true }
      end,
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      optional = true,
      opts = { ensure_installed = { { "pyink", condition = function() return vim.fn.executable("python3") == 1 end } } },
    },
    {
      "folke/snacks.nvim",
      optional = true,
      -- same flags conform.nvim's format_on_save reads (astrocommunity conform-nvim)
      opts = function()
        local toggle = require("snacks.toggle")
        toggle
          .new({
            name = "autoformatting (buffer)",
            get = function() return vim.F.if_nil(vim.b.autoformat, vim.g.autoformat, true) end,
            set = function(state) vim.b.autoformat = state end,
          })
          :map("<Leader>uf")
        toggle
          .new({
            name = "autoformatting (global)",
            get = function() return vim.F.if_nil(vim.g.autoformat, true) end,
            set = function(state)
              vim.g.autoformat, vim.b.autoformat = state, nil
            end,
          })
          :map("<Leader>uF")
      end,
    },
  },
}
