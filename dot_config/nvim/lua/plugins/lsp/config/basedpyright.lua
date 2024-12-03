---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      basedpyright = {
        before_init = function(_, c)
          if not c.settings then c.settings = {} end
          if not c.settings.python then c.settings.python = {} end
          c.settings.python.pythonPath = (vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV .. "/bin/python3")
            or vim.fn.exepath("python3")
        end,
        on_attach = function()
          vim.api.nvim_create_autocmd("LspTokenUpdate", {
            callback = function(args)
              local token = args.data.token
              if token.type == "decorator" and not token.modifiers.readonly then
                vim.lsp.semantic_tokens.highlight_token(
                  token,
                  args.buf,
                  args.data.client_id,
                  "@lsp.type.decorator.python",
                  { priority = 130 }
                )
              end
            end,
          })
        end,
        settings = {
          basedpyright = {
            analysis = {
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              autoSearchPath = true,
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportUnusedImport = "information",
                reportUnusedFunction = "information",
                reportUnusedVariable = "information",
                reportGeneralTypeIssues = "none",
                reportOptionalMemberAccess = "none",
                reportOptionalSubscript = "none",
                reportPrivateImportUsage = "none",
              },
            },
          },
        },
      },
    },
  },
}
