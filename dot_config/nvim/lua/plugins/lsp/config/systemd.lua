if vim.fn.executable("systemd_ls") == 0 then return {} end
---@type LazySpec
return {
  "AstroNvim/astrolsp",
  opts_extend = { "servers" },
  ---@type AstroLSPOpts
  opts = {
    servers = { "systemd_ls" },
    ---@diagnostic disable-next-line: missing-fields
    config = {
      systemd_ls = {
        cmd = { "systemd_ls" },
        filetypes = { "systemd" },
        root_dir = function() return nil end,
        single_file_support = true,
        settings = {},
        docs = {
          description = [[
https://github.com/psacawa/systemd-language-server
Language Server for Systemd unit files.

I tested it with python 3.10.15
3.12.7 didn't work
]],
        },
      },
    },
  },
}
