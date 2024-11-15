---@type LazySpec
return {
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
}
