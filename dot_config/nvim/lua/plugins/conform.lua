---@type LazySpec
return {
  "stevearc/conform.nvim",
  optional = true,
  opts = {
    formatters_by_ft = {
      http = { "kulala-fmt" },
      python = { "pyink" },
      -- never fall back to lua_ls formatting (conform ignores `filter` in default_format_opts)
      lua = { "stylua", lsp_format = "never" },
    },
  },
  specs = {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      -- <Leader>uf/<Leader>uF are snacks toggles in snacks-toggle.lua
      maps.n["<Leader>uf"] = false
      maps.n["<Leader>uF"] = false
      -- :Format formats whole lines; conform's own visual range drops the last char and stylua skips that line
      maps.v["<Leader>lf"] = { ":Format<CR>", desc = "Format selection", silent = true }
    end,
  },
}
