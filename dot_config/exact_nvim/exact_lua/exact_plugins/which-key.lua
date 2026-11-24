---@type LazySpec
return {
  "RayJameson/which-key.nvim",
  name = "which-key.nvim",
  optional = true,
  opts = {
    preset = "modern",
    delay = 0,
    triggers = {
      { "<auto>", mode = "nxso" },
    },
  },
}
