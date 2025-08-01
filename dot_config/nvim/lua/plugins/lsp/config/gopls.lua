---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      gopls = {
        settings = {
          gopls = {
            analyses = {
              unusedfunc = false, -- covered by golangci-lint
            },
            completeFunctionCalls = false,
            codelenses = {
              generate = true, -- show the `go generate` lens.
              test = true,
              tidy = true,
              vendor = true,
              regenerate_cgo = true,
              upgrade_dependency = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            semanticTokens = true,
            usePlaceholders = false,
          },
        },
      },
    },
  },
}
