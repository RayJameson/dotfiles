---@type LazySpec
return {
  {
    "xvzc/chezmoi.nvim",
    optional = true,
    opts = {
      edit = {
        watch = true,
        force = false,
      },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>f."] = {
            function() require("telescope").extensions.chezmoi.find_files() end,
            desc = "Find chezmoi config",
          },
        },
      },
    },
  },
}
