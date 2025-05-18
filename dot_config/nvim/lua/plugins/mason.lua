---@return fun(): boolean
local function is_executable(binary)
  return function() return vim.fn.executable(binary) == 1 end
end
if not is_executable("npm")() then return {} end

local list_insert_unique = require("astrocore").list_insert_unique
-- customize mason plugins
---@type LazySpec
return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        unpack(
          vim
            .iter({ "iferr", "delve", "goimports", "gopls", "gofumpt", "goimports", "gomodifytags" })
            :map(function(tool) return { tool, condition = is_executable("go") } end)
            :totable()
        ),
        unpack(
          vim
            .iter({ "basedpyright", "ruff", "debugpy" })
            :map(function(tool) return { tool, condition = is_executable("python3") } end)
            :totable()
        ),
        "bash-language-server",
        "json-lsp",
        "taplo",
        "lua-language-server",
        "vim-language-server",
        "yaml-language-server",
        "marksman",
        "hadolint",
        "luacheck",
        "selene",
        "stylua",
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        height = 0.8,
        backdrop = 100,
      },
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      opts.handlers = {
        luacheck = function() end,
        stylua = function() end,
        mypy = function() end,
      }
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      { "mfussenegger/nvim-dap-python", lazy = true },
      -- HACK: to ignore crash prompt on MacOS after terminating debugger, run this command:
      -- defaults write com.apple.CrashReporter DialogType none
      -- to enable it back, run this:
      -- defaults write com.apple.CrashReporter DialogType prompt
      -- credit: https://github.com/mfussenegger/nvim-dap-python/issues/151#issuecomment-2221639990
    },
    opts = function(_, opts)
      opts.handlers = {
        python = function(config)
          config.configurations = list_insert_unique(config.configurations, {
            {
              type = "python",
              request = "launch",
              name = "Python: Debug Current File",
              program = "${file}",
              justMyCode = false,
              console = "integratedTerminal",
              cwd = vim.uv.cwd(),
              args = {
                "-m",
                "debugpy.adapter",
              },
              env = {
                PYTHONPATH = table.concat({ vim.uv.cwd(), "src" }, ":"),
                PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "4",
              },
              pythonPath = function() return "python" end,
            },
            {
              type = "python",
              request = "launch",
              name = "Python: Debug FastAPI web application",
              module = "uvicorn",
              cwd = vim.uv.cwd(),
              env = {
                PYTHONPATH = table.concat({ vim.uv.cwd(), "src" }, ":"),
                PYDEVD_WARN_SLOW_RESOLVE_TIMEOUT = "4",
              },
              args = {
                "-m",
                "debugpy.adapter",
                "main:app",
                "--use-colors",
              },
              pythonPath = function() return "python" end,
              console = "integratedTerminal",
            },
          })
          require("mason-nvim-dap").default_setup(config) -- don't forget this!
          local path = vim.fn.exepath("python")
          local debugpy = require("mason-registry").get_package("debugpy")
          if debugpy:is_installed() then path = vim.env.MASON .. "/packages/debugpy/venv/bin/python" end
          require("dap-python").setup(path, opts)
        end,
      }
    end,
  },
}
