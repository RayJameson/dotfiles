---@type LazySpec
return {
  "alker0/chezmoi.vim",
  lazy = false,
  specs = {
    {
      "AstroNvim/astrocore",
      opts = {
        options = {
          g = {
            ["chezmoi#use_tmp_buffer"] = 1,
            ["chezmoi#source_dir_path"] = vim.env.HOME .. "/.local/share/chezmoi",
          },
        },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts.highlight.disable = function(_, bufnr)
          if vim.bo[bufnr].filetype == "chezmoitmpl" then return true end
        end
      end,
    },
  },
}
