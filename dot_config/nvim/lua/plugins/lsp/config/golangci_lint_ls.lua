---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      golangci_lint_ls = {
        init_options = {
          command = (function()
            local util = require("lspconfig.util")
            local args = {
              "golangci-lint",
              "run",
              "--output.json.path",
              "stdout",
              "--show-stats=false",
              "--issues-exit-code=1",
            }
            if
              not util.root_pattern(unpack { ".golangci.yaml", ".golangci.yml", ".golangci.toml", ".golangci.json" })()
            then
              table.insert(
                args,
                "--config=" .. (vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config") .. "/golangci.yaml"
              )
            end
            return args
          end)(),
        },
      },
    },
  },
}
