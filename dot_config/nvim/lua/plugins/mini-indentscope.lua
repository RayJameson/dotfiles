---@type LazySpec
return {
  "echasnovski/mini.indentscope",
  optional = true,
  opts = {
    symbol = "│",
  },
  specs = {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      autocmds = {
        MiniIndentcopePython = {
          {
            event = "FileType",
            pattern = "python",
            desc = "Set borders to 'top' for python in mini.indentscope",
            callback = function()
              vim.b.miniindentscope_config = {
                options = {
                  border = "top",
                },
              }
            end,
          },
        },
        MiniIndentcopeTrouble = {
          {
            event = "FileType",
            pattern = "trouble",
            desc = "Disable in trouble window",
            callback = function() vim.b.miniindentscope_disable = true end,
          },
        },
      },
    },
  },
}
