---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  optional = true,
  opts = {
    direction = "float",
    autochdir = true,
    float_opts = {
      width = function()
        return require("utilities").calculate_percent(vim.api.nvim_win_get_width(0), 95)
      end,
      height = function()
        return require("utilities").calculate_percent(vim.api.nvim_win_get_height(0), 95)
      end,
    },
  },
  specs = {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      if vim.fn.executable("yazi") == 1 then
        maps.n["<Leader>ty"] = {
          function()
            require("astrocore").toggle_term_cmd("yazi")
          end,
          desc = "ToggleTerm yazi",
        }
      end
    end,
  },
}
