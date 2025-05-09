local prefix = "<Leader>g"
---@type LazySpec
return {
  "lewis6991/gitsigns.nvim",
  keys = {
    { prefix .. "P", function() require("gitsigns").preview_hunk() end, desc = "Preview Git hunk in pop up" },
    { prefix .. "R", function() require("gitsigns").reset_buffer() end, desc = "Reset Git buffer" },
    { prefix .. "r", function() require("gitsigns").reset_hunk() end, desc = "Reset Git hunk" },
    { prefix .. "D", function() require("gitsigns").preview_hunk_inline() end, desc = "Toggle deleted lines" },
    { prefix .. "w", function() require("gitsigns").toggle_word_diff() end, desc = "Toggle word diff" },
  },
  opts = {
    sign_priority = 50,
  },
}
