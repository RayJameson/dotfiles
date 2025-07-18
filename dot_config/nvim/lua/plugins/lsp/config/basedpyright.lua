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
        settings = {
          basedpyright = {
            analysis = {
              diagnosticMode = "workspace",
              typeCheckingMode = "basic",
              autoImportCompletions = true,
              autoSearchPath = true,
              useLibraryCodeForTypes = true,
              inlayHints = {
                callArgumentNamesMatching = true,
                genericTypes = true,
              },
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
