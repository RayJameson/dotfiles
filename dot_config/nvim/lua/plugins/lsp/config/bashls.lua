---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      bashls = {
        settings = {
          bashIde = {
            shellcheckArguments = "-e SC2034",
          },
        },
      },
    },
  },
}
