local prefix = "<Leader>r"
---@type LazySpec
return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction",
      "OverseerClearCache",
    },
    specs = {
      { "AstroNvim/astroui", opts = { icons = { Overseer = "󰜎" } } },
      {
        "AstroNvim/astrocore",
        opts = function(_, opts)
          return require("astrocore").extend_tbl(opts, {
            mappings = {
              n = {
                [prefix] = { desc = require("astroui").get_icon("Overseer", 1, false) .. "Overseer" },
                [prefix .. "i"] = { "<Cmd>OverseerInfo<CR>", desc = "Open Info" },
                [prefix .. "r"] = { "<Cmd>OverseerRun<CR>", desc = "Open tasks" },
                [prefix .. "<CR>"] = { "<Cmd>OverseerToggle<CR>", desc = "Open Panel" },
                [prefix .. "s"] = { "<Cmd>OverseerRun shell<CR>", desc = "Run shell" },
                [prefix .. "f"] = { "<Cmd>OverseerRun run\\ file<CR>", desc = "Run file" },
                [prefix .. "F"] = {
                  "<Cmd>OverseerRun run\\ file\\ in\\ background<CR>",
                  desc = "Run file in background",
                },
                [prefix .. "h"] = {
                  "<Cmd>OverseerRun run file in horizontal split<CR>",
                  desc = "Run file in horizontal split",
                },
                [prefix .. "t"] = { "<Cmd>OverseerRun run\\ file\\ in\\ new\\ tab<CR>", desc = "Run file in new tab" },
                [prefix .. "l"] = { "<Cmd>OverseerLoadBundle<CR>", desc = "Load task bundle" },
                [prefix .. "B"] = { "<Cmd>OverseerBuild<CR>", desc = "Create new task" },
              },
            },
            commands = {
              C = {
                function(params)
                  local tmpl_params = {
                    cmd = params.args ~= "" and params.args or nil,
                    components = {
                      "on_output_summarize",
                      { "on_complete_dispose", timeout = 30 },
                      "default",
                    },
                    strategy = {
                      "toggleterm",
                      use_shell = true,
                      open_on_start = params.bang,
                      on_create = function() vim.cmd.stopinsert() end,
                    },
                  }
                  if not tmpl_params.cmd then return end
                  require("overseer").run_template {
                    name = "shell",
                    params = tmpl_params,
                  }
                end,
                nargs = "*",
                bang = true,
                desc = "Async run shell command",
                complete = "shellcmdline",
              },
              Make = {
                function(params)
                  -- Insert args at the '$*' in the makeprg
                  local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
                  if num_subs == 0 then cmd = cmd .. " " .. params.args end
                  local task = require("overseer").new_task {
                    cmd = vim.fn.expandcmd(cmd),
                    components = {
                      { "on_output_quickfix", open = not params.bang, open_height = 8 },
                      "default",
                    },
                    strategy = {
                      "toggleterm",
                      use_shell = true,
                      open_on_start = false,
                    },
                  }
                  task:start()
                end,
                desc = "Run your makeprg as an Overseer task",
                nargs = "*",
                bang = true,
              },
              Grep = {
                function(params)
                  -- Insert args at the '$*' in the grepprg
                  local cmd, num_subs = vim.o.grepprg:gsub("%$%*", params.args)
                  if num_subs == 0 then cmd = cmd .. " " .. params.args end
                  local task = require("overseer").new_task {
                    cmd = vim.fn.expandcmd(cmd),
                    components = {
                      {
                        "on_output_quickfix",
                        errorformat = vim.o.grepformat,
                        open = not params.bang,
                        open_height = 8,
                        items_only = true,
                      },
                      -- We don't care to keep this around as long as most tasks
                      { "on_complete_dispose", timeout = 30 },
                      "default",
                    },
                    strategy = {
                      "toggleterm",
                      use_shell = true,
                      open_on_start = false,
                    },
                  }
                  task:start()
                end,
                nargs = "*",
                bang = true,
                complete = "file",
              },
            },
          })
        end,
      },
      {
        "Saghen/blink.cmp",
        optional = true,
        opts = {
          sources = {
            default = { "overseer" },
            providers = {
              overseer = { name = "overseer", module = "blink.compat.source", score_offset = -1 },
            },
          },
        },
      },
    },
    opts = {
      strategy = "toggleterm",
      task_list = {
        direction = "bottom",
        max_height = { 100, 0.99 },
        height = 100,
        max_width = { 40, 0.4 },
        min_width = { 10, 0.1 },
        width = 40,
        bindings = {
          ["<C-l>"] = false,
          ["<C-h>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["p"] = false,
          q = "<Cmd>close<CR>",
          K = "IncreaseDetail",
          J = "DecreaseDetail",
          ["<C-p>"] = "ScrollOutputUp",
          ["<C-n>"] = "ScrollOutputDown",
          ["dd"] = "<Cmd>OverseerQuickAction dispose<CR>",
        },
      },
    },
    config = function(_, opts)
      --- Run with runner
      ---@param runner string | table
      ---@return function
      local function run_with(runner)
        vim.validate { runner = { runner, { "table", "string" } } }
        return function(file)
          if type(runner) == "string" then
            return { runner, file }
          elseif type(runner) == "table" then
            return vim.iter({ runner, { file } }):flatten():totable()
          end
        end
      end

      local filetype_to_cmd = {
        python = run_with("python"),
        sh = run_with("sh"),
        zsh = run_with("zsh"),
        bash = run_with("bash"),
        javascript = run_with("node"),
        typescript = run_with("node"),
        lua = run_with("luaj"),
        perl = run_with("perl"),
        html = run_with("xdg-open"),
        go = run_with { "go", "run" },
        rust = run_with { "cargo", "run" },
      }

      ---@param run_in_foreground boolean
      ---@param direction "dock"|"float"|"tab"|"vertical"|"horizontal"
      ---@param on_create? function
      ---@return fun(): overseer.TaskDefinition
      local function create_builder(run_in_foreground, direction, on_create)
        ---@return overseer.TaskDefinition
        local function builder()
          local file = vim.fn.expand("%:p")
          local cmd = filetype_to_cmd[vim.bo.filetype](file)
          local task = {
            cmd = cmd,
            strategy = {
              "toggleterm",
              use_shell = true,
              on_create = on_create,
              direction = direction,
              hidden = true,
            },
            components = {
              { "display_duration", detail_level = 2 },
              "on_output_summarize",
              "on_exit_set_status",
              { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
            },
          }
          task.strategy.open_on_start = run_in_foreground and true or false
          return task
        end

        return builder
      end
      require("overseer").setup(opts)
      vim.tbl_map(require("overseer").register_template, {
        {
          name = "run file in background",
          builder = create_builder(false, "dock", function() vim.cmd.stopinsert() end),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file in background",
        },
        {
          name = "run file",
          builder = create_builder(true, "float", function() vim.cmd.stopinsert() end),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file",
        },
        {
          name = "run file in new tab",
          builder = create_builder(true, "tab", function() vim.cmd.stopinsert() end),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file in a new tab",
        },
        {
          name = "run file in horizontal split",
          builder = create_builder(true, "horizontal", function() vim.cmd.stopinsert() end),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file in a horizontal split",
        },
        {
          name = "run python module",
          builder = function()
            local python_module, _ = vim.fn.expand("%:p:.:r"):gsub("/", ".")
            return {
              cmd = { "python3" },
              args = { "-m", python_module },
              env = { PYTHONPATH = "src" .. ":" .. vim.uv.cwd() },
              strategy = {
                "toggleterm",
                use_shell = true,
                on_create = function() vim.cmd.stopinsert() end,
                open_on_start = true,
                direction = "tab",
                hidden = true,
              },
            }
          end,
          condition = { filetype = "python" },
          desc = "Run with `-m` flag",
        },
        {
          name = "run python module in background",
          builder = function()
            local python_module, _ = vim.fn.expand("%:p:.:r"):gsub("/", ".")
            return {
              cmd = { "python3" },
              args = { "-m", python_module },
              env = { PYTHONPATH = "src" .. ":" .. vim.uv.cwd() },
              strategy = {
                "toggleterm",
                use_shell = true,
                open_on_start = false,
                direction = "tab",
                hidden = true,
              },
            }
          end,
          condition = { filetype = "python" },
          desc = "Run with `-m` flag",
        },
        {
          name = "uv virtualenv",
          desc = "Setup uv environment for project",
          params = function()
            local stdout = vim
              .system({ "uv", "python", "list", "--managed-python", "--all-versions", "--output-format", "json" })
              :wait().stdout
            assert(stdout)
            local versions = vim.tbl_map(function(t) return t.version end, vim.json.decode(stdout))
            return {
              version = {
                desc = "Python version to use for venv",
                type = "enum",
                choices = versions,
              },
            } --[[@as overseer.Params]]
          end,
          builder = function(params)
            return {
              name = "uv virtualenv",
              strategy = {
                "orchestrator",
                tasks = {
                  { cmd = { "uv" }, args = { "venv", "-p", params.version } },
                },
              },
            }
          end,
        } --[[@as overseer.TemplateDefinition]],
        {
          name = "setup uv dev",
          desc = "Setup python uv venv and install packages",
          builder = function()
            return {
              name = "setup uv dev",
              strategy = {
                "orchestrator",
                tasks = {
                  { "uv virtualenv" },
                  { cmd = "uv sync --no-install-project" },
                },
              },
            }
          end,
        } --[[@as overseer.TemplateDefinition]],
        {
          name = "pyenv virtualenv",
          desc = "Setup pyenv environment for project",
          params = function()
            local stdout = vim.system({ "pyenv", "versions", "--bare", "--skip-aliases", "--skip-envs" }):wait().stdout
            assert(stdout)
            local versions = vim.split(stdout, "\n", { trimempty = true })
            return {
              version = {
                desc = "Python version to use for venv",
                type = "enum",
                choices = versions,
              },
              virtualenv_name = {
                desc = "Name for virtual environment, default: project dir name",
                type = "string",
                default = vim.fn.expand("%:p:h:t"),
              },
            } --[[@as overseer.Params]]
          end,
          builder = function(params)
            return {
              name = "pyenv virtualenv",
              strategy = {
                "orchestrator",
                tasks = {
                  { cmd = { "pyenv" }, args = { "virtualenv", params.version, params.virtualenv_name } },
                  { cmd = { "pyenv" }, args = { "local", params.virtualenv_name } },
                },
              },
            }
          end,
        } --[[@as overseer.TemplateDefinition]],
        {
          name = "setup pyenv dev",
          desc = "Setup python pyenv venv and install packages",
          builder = function()
            return {
              name = "setup pyenv dev",
              strategy = {
                "orchestrator",
                tasks = {
                  { "pyenv virtualenv" },
                  {
                    cmd = 'eval "$(pyenv init -)" && '
                      .. 'eval "$(pyenv virtualenv-init -)" && '
                      .. "pyenv activate && "
                      .. "poetry install --no-root",
                  },
                },
              },
            }
          end,
        } --[[@as overseer.TemplateDefinition]],
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
  },
}
