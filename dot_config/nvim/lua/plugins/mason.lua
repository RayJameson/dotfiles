if vim.fn.executable("npm") == 0 then return {} end

local list_insert_unique = require("astrocore").list_insert_unique
-- customize mason plugins
---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "lua:custom-registry", -- custom user registry
        "github:mason-org/mason-registry", -- make sure to add the default registry
      },
      ui = {
        border = "rounded",
        height = 0.8,
        backdrop = 100,
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local cmd = vim.api.nvim_create_user_command
      cmd("MasonUpdate", function(options) require("astrocore.mason").update(options.fargs) end, {
        nargs = "*",
        desc = "Update Mason Package",
        complete = function(arg_lead)
          local _ = require("mason-core.functional")
          return _.sort_by(
            _.identity,
            _.filter(_.starts_with(arg_lead), require("mason-registry").get_installed_package_names())
          )
        end,
      })
      cmd("MasonUpdateAll", function() require("astrocore.mason").update_all() end, { desc = "Update Mason Packages" })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      local servers = {
        "lua_ls",
        "vimls",
        "jsonls",
        "yamlls",
      }
      if vim.fn.executable("python3") == 1 then list_insert_unique(servers, { "ruff", "basedpyright" }) end
      if vim.fn.executable("go") == 1 then list_insert_unique(servers, { "gopls" }) end
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, servers)
    end,
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = function(_, opts)
      -- add more things to the ensure_installed table protecting against community packs modifying it
      local utils = {
        -- "prettier",
        "stylua",
      }
      -- if vim.fn.executable("python3") == 1 then table.insert(utils, "pyink") end
      opts.ensure_installed = list_insert_unique(opts.ensure_installed, utils)
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
    init = function() end,
    opts = function(_, opts)
      if vim.fn.executable("python3") == 1 then list_insert_unique(opts.ensure_installed, { "python" }) end
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
          if debugpy:is_installed() then path = debugpy:get_install_path() .. "/venv/bin/python" end
          require("dap-python").setup(path, opts)
        end,
      }
    end,
  },
}
