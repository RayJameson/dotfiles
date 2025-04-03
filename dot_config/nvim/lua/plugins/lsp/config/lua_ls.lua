---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      lua_ls = {
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            hover = {
              expandAlias = false,
              previewFields = 100,
              enumsLimit = 100,
            },
            hint = {
              enable = true,
              arrayIndex = "Disable",
            },
            workspace = {
              checkThirdParty = false,
            },
            diagnostics = {
              disable = { "lowercase-global" },
            },
            codelens = {
              enable = true,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
    },
  },
}
