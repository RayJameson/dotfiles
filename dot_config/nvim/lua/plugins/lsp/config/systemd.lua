if vim.fn.executable("systemd-language-server") == 0 then return {} end
---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts_extend = { "servers" },
  ---@type AstroLSPOpts
  opts = {
    servers = { "systemd-language-server" },
    ---@diagnostic disable-next-line: missing-fields
    config = {
      ["systemd-language-server"] = {
        cmd = { "systemd-language-server" },
        filetypes = { "systemd" },
        root_dir = function() return nil end,
        single_file_support = true,
        settings = {},
        docs = {
          description = [[
https://github.com/RayJameson/systemd-language-server
Language Server for Systemd unit files.

I tested it with python 3.10.15
3.12.7 didn't work
]],
        },
      },
    },
  },
}
