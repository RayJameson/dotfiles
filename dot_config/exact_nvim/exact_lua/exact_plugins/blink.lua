---@type LazySpec
return {
  "Saghen/blink.cmp",
  version = "*",
  opts = {
    cmdline = { enabled = true },
    completion = {
      ghost_text = {
        enabled = false,
        show_with_menu = false,
        show_with_selection = false,
        show_without_menu = false,
      },
    },
  },
}
