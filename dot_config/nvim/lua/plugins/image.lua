---@type LazySpec
return {
  "3rd/image.nvim",
  cond = not vim.g.neovide,
  enabled = vim.fn.executable("magick") == 1,
  ft = { "markdown", "vimwiki", "norg", "html", "css" },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      optional = true,
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed =
            require("astrocore").list_insert_unique(opts.ensure_installed, { "markdown", "markdown_inline" })
        end
      end,
    },
  },
  opts = {
    backend = "kitty",
    window_overlap_clear_enabled = true,
    editor_only_render_when_focused = true,
    tmux_show_only_in_active_window = true,
    integrations = {
      markdown = {
        enabled = true,
        clear_in_insert_mode = true,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        floating_windows = true,
        filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
      },
      neorg = {
        enabled = true,
        clear_in_insert_mode = false,
        download_remote_images = true,
        only_render_image_at_cursor = true,
        filetypes = { "norg" },
      },
      html = {
        enabled = true,
      },
      css = {
        enabled = true,
      },
    },
  },
}
