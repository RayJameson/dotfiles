local source_dir = vim.env.HOME .. "/.local/share/chezmoi"

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
            ["chezmoi#source_dir_path"] = source_dir,
          },
        },
        -- AstroNvim replays filetype detection after lazy-loading, which resets chezmoi.vim's *.chezmoitmpl to `template`
        filetypes = {
          pattern = {
            [vim.pesc(source_dir) .. "/.*%.tmpl"] = function(_, bufnr)
              local ft = vim.bo[bufnr].filetype
              if ft:find("chezmoitmpl", 1, true) then return ft end
            end,
          },
        },
      },
    },
    -- chezmoi templates aren't valid Lua: skip lua linters/formatters
    {
      "mfussenegger/nvim-lint",
      optional = true,
      opts = { linters_by_ft = { ["lua.chezmoitmpl"] = {} } },
    },
    {
      "stevearc/conform.nvim",
      optional = true,
      -- an empty `{}` would fall through to `lua` in conform
      opts = { formatters_by_ft = { ["lua.chezmoitmpl"] = { lsp_format = "never" } } },
    },
    {
      "echasnovski/mini.icons",
      optional = true,
      opts = {
        file = {
          [".chezmoiignore"] = { glyph = "", hl = "MiniIconsGrey" },
          [".chezmoiremove"] = { glyph = "", hl = "MiniIconsGrey" },
          [".chezmoiroot"] = { glyph = "", hl = "MiniIconsGrey" },
          [".chezmoiversion"] = { glyph = "", hl = "MiniIconsGrey" },
          ["bash.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["json.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["ps1.tmpl"] = { glyph = "󰨊", hl = "MiniIconsGrey" },
          ["sh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["toml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["yaml.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
          ["zsh.tmpl"] = { glyph = "", hl = "MiniIconsGrey" },
        },
      },
    },
  },
}
