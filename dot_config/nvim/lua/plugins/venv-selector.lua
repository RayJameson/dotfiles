---@type LazySpec
return {
  "linux-cultist/venv-selector.nvim",
  enabled = vim.tbl_contains(
    { "fd", "fdfind", "fd-find" },
    function(v) return vim.fn.executable(v) == 1 end,
    { predicate = true }
  ),
  ft = "python",
  opts = {},
  config = function(_, opts)
    -- NOTE: do not update dap python path, we do it lazily in dap config
    local venv_selector_path = require("venv-selector.path")
    ---@diagnostic disable-next-line: duplicate-set-field
    venv_selector_path.update_python_dap = function() end
    require("venv-selector").setup(opts)
  end,
  cmd = "VenvSelect",
  specs = {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<Leader>lv"] = { "<Cmd>VenvSelect<CR>", desc = "Select VirtualEnv" },
        },
      },
      autocmds = {
        VenvSelector = {
          {
            event = "DirChanged",
            desc = "Disable venv on change dir",
            callback = function()
              local venv_selector = require("venv-selector")
              if not venv_selector.venv() then return end
              venv_selector.deactivate()
              venv_selector.stop_lsp_servers()
            end,
          },
        },
      },
    },
  },
}
