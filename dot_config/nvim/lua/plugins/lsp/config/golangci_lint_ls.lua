---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      golangci_lint_ls = {
        -- resolved per project root at server start, not once at nvim startup
        before_init = function(params, config)
          local command = {
            "golangci-lint",
            "run",
            "--output.json.path",
            "stdout",
            "--show-stats=false",
            "--issues-exit-code=1",
          }
          local markers = { ".golangci.yaml", ".golangci.yml", ".golangci.toml", ".golangci.json" }
          if not vim.fs.root(config.root_dir or vim.uv.cwd(), markers) then
            table.insert(
              command,
              "--config=" .. (vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config") .. "/golangci.yaml"
            )
          end
          params.initializationOptions =
            vim.tbl_extend("force", params.initializationOptions or {}, { command = command })
        end,
      },
    },
  },
}
