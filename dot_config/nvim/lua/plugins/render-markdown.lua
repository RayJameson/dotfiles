return {
  "MeanderingProgrammer/render-markdown.nvim",
  cmd = "RenderMarkdown",
  ft = "markdown",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed =
            require("astrocore").list_insert_unique(opts.ensure_installed, { "html", "markdown", "markdown_inline" })
        end
      end,
    },
  },
  opts = {
    completions = {
      lsp = { enabled = true },
      blink = { enabled = true },
    },
    render_modes = { "n", "c", "v" },
    win_options = {
      conceallevel = {
        rendered = 3,
      },
      concealcursor = {
        rendered = "nc",
      },
    },
    anti_conceal = {
      enabled = false,
    },
    code = {
      border = false,
    },
  },
}
