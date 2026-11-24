---@type LazySpec
return {
  -- HACK: to ignore crash prompt on MacOS after terminating debugger, run this command:
  -- defaults write com.apple.CrashReporter DialogType none
  -- to enable it back, run this:
  -- defaults write com.apple.CrashReporter DialogType prompt
  -- credit: https://github.com/mfussenegger/nvim-dap-python/issues/151#issuecomment-2221639990
  "mfussenegger/nvim-dap",
  specs = {
    { "AstroNvim/astroui", opts = { icons = { Debugger = "" } } },
    {
      "AstroNvim/astrocore",
      opts = function(
        _,
        opts --[[@as AstroCoreOpts]]
      )
        local maps = opts.mappings
        maps.n["<Leader>d"] = { desc = require("astroui").get_icon("Debugger", 1, false) .. "Debugger" }
        maps.n["<F8>"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" }
        maps.n["<F9>"] = { function() require("dap").step_over() end, desc = "Step Over" }
        maps.n["<F10>"] = { function() require("dap").step_into() end, desc = "Step Into" }
        maps.n["<S-F10>"] = { function() require("dap").step_out() end, desc = "Step Out (S-F10)" } -- Shift+F10
        maps.n["<Leader>db"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F8)" }
        maps.n["<Leader>di"] = { function() require("dap").step_into() end, desc = "Step Into (F10)" }
        maps.n["<Leader>dO"] = { function() require("dap").step_out() end, desc = "Step Out (S-F10)" }
        maps.n["<Leader>do"] = { function() require("dap").step_over() end, desc = "Step Over (F9)" }
        maps.n["<Leader>da"] = { function() require("dap").step_back() end, desc = "Step Back (S-F9)" }
        maps.n["<S-F9>"] = { function() require("dap").step_back() end, desc = "Step Back (S-F9)" }
        maps.n["<Leader>dd"] = { function() require("dap").disconnect() end, desc = "Disconnect" }
        maps.n["<C-F5>"] = { function() require("dap").restart_frame() end, desc = "Restart" } -- Control+F5
        maps.n["<S-F5>"] = { function() require("dap").terminate() end, desc = "Stop" } -- Shift+F5
        maps.n["<Leader>dh"] = {
          ---@diagnostic disable-next-line: missing-fields
          function() require("dapui").eval(nil, { enter = true }) end,
          desc = "Hover",
        }
        maps.n["<Leader>dC"] = {
          function()
            vim.ui.input({ prompt = "Condition: " }, function(condition)
              if condition then require("dap").set_breakpoint(condition) end
            end)
          end,
          desc = "Conditional Breakpoint (S-F8)",
        }
        maps.n["<S-F8>"] = { -- Shift+F8
          function()
            vim.ui.input({ prompt = "Condition: " }, function(condition)
              if condition then require("dap").set_breakpoint(condition) end
            end)
          end,
          desc = "Conditional Breakpoint",
        }
        maps.n["<F21>"] = false
        maps.n["<F20>"] = { -- Shift+F8
          function()
            vim.ui.input({ prompt = "Condition: " }, function(condition)
              if condition then require("dap").set_breakpoint(condition) end
            end)
          end,
          desc = "Conditional Breakpoint",
        }

        maps.n["<F11>"] = false
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      dependencies = { "LiadOz/nvim-dap-repl-highlights", opts = {} },
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "dap_repl" })
        end
      end,
    },
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      optional = true,
      opts = { ensure_installed = { { "debugpy", condition = function() return vim.fn.executable("python3") == 1 end } } },
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { { "mfussenegger/nvim-dap-python", lazy = true } },
      opts = function(_, opts)
        opts.handlers = {
          python = function(config)
            config.configurations = require("astrocore").list_insert_unique(config.configurations, {
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
  },
  dependencies = {
    { "theHamsta/nvim-dap-virtual-text", config = true },
    {
      "rcarriga/nvim-dap-ui",
      config = function(plugin, opts)
        opts.controls = { enabled = false }
        opts.icons = {
          collapsed = "",
          current_frame = "",
          expanded = "",
        }
        opts.layouts = {
          {
            -- You can change the order of elements in the sidebar
            elements = {
              -- Provide IDs as strings or tables with "id" and "size" keys
              {
                id = "scopes",
                size = 0.25, -- Can be float or integer > 1
              },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = vim.g.neovide and 8 or 9,
            position = "bottom", -- Can be "bottom" or "top"
          },
        }
        require("astronvim.plugins.configs.nvim-dap-ui")(plugin, opts)
      end,
    },
  },
}
