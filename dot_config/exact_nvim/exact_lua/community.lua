---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.rust", enabled = vim.fn.executable("rustc") == 1 },
  { import = "astrocommunity.pack.go", enabled = vim.fn.executable("go") == 1 },
  { import = "astrocommunity.pack.templ", enabled = vim.fn.executable("go") == 1 },
  { import = "astrocommunity.pack.docker", enabled = vim.fn.executable("docker") == 1 },
  { import = "astrocommunity.pack.yaml", enabled = vim.fn.executable("npm") == 1 },
  { import = "astrocommunity.pack.json", enabled = vim.fn.executable("npm") == 1 },
  { import = "astrocommunity.pack.html-css", enabled = vim.fn.executable("npm") == 1 },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.quickfix.nvim-bqf" },
  { import = "astrocommunity.quickfix.quicker-nvim" },
  { import = "astrocommunity.recipes.vscode" },
  { import = "astrocommunity.pack.hyprlang" },
  { import = "astrocommunity.pack.xml" },
  {
    "nvim-bqf",
    optional = true,
    opts = {
      preview = {
        winblend = 0,
        auto_resize_height = true,
        win_height = 999,
        border = "none",
        show_scroll_bar = false,
      },
    },
  },
  {
    "todo-comments.nvim",
    optional = true,
    opts = {
      keywords = {
        TEST = {
          icon = " ",
          color = "test",
          alt = { "TESTING", "TEST PASSED", "TEST FAILED" },
        },
        NOTE = {
          icon = "󱞁 ",
          color = "hint",
          alt = { "INFO" },
        },
        PERF = { icon = "󱁤 ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        TODO = { alt = { "ToDo" } },
      },
      colors = {
        error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
        warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
        info = "#61afef",
        hint = "#10B981",
        default = "#c882e7",
        test = "#cbcb41",
      },
    },
  },
}
