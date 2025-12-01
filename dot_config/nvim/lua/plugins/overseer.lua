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
                [prefix .. "<CR>"] = {
                  function()
                    vim.cmd([[OverseerToggle]])
                    vim.defer_fn(vim.cmd.stopinsert, 10)
                  end,
                  desc = "Open Panel",
                },
                [prefix .. "f"] = { "<Cmd>OverseerRun run\\ file<CR>", desc = "Run file" },
                [prefix .. "F"] = {
                  "<Cmd>OverseerRun run\\ file\\ in\\ background<CR>",
                  desc = "Run file in background",
                },
                [prefix .. "h"] = {
                  "<Cmd>OverseerRun run\\ file\\ in\\ horizontal\\ split<CR>",
                  desc = "Run file in horizontal split",
                },
                [prefix .. "t"] = { "<Cmd>OverseerRun run\\ file\\ in\\ new\\ tab<CR>", desc = "Run file in new tab" },
              },
            },
            commands = {
              S = {
                function(params)
                  local cmd = params.args ~= "" and params.args or nil
                  local components = {
                    "shell_hook.interactive",
                    "on_exit_set_status",
                    { "on_complete_dispose", timeout = 30 },
                  }
                  if not cmd then return end
                  if params.bang then
                    table.insert(components, "on_complete_notify")
                  else
                    table.insert(components, { "open_output", direction = "horizontal", focus = true })
                  end
                  local task = require("overseer").new_task {
                    cmd = cmd,
                    components = components,
                    strategy = { "jobstart", use_terminal = true },
                  }
                  task:start()
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
                    strategy = { "jobstart", use_terminal = true },
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
                  local components = {
                    {
                      "on_output_quickfix",
                      errorformat = vim.o.grepformat,
                      open = not params.bang,
                      focus = not params.bang,
                      open_height = 8,
                      items_only = true,
                    },
                    -- We don't care to keep this around as long as most tasks
                    { "on_complete_dispose", timeout = 30 },
                    "on_exit_set_status",
                  }
                  if params.bang then table.insert(components, "on_complete_notify") end
                  local task = require("overseer").new_task {
                    cmd = vim.fn.expandcmd(cmd),
                    components = components,
                    strategy = { "jobstart", use_terminal = true },
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
      task_win = {
        border = "rounded",
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
        python = run_with("python3"),
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
      ---@param direction? "dock"|"float"|"tab"|"vertical"|"horizontal"
      ---@return fun(): overseer.TaskDefinition
      local function create_builder(run_in_foreground, direction)
        ---@return overseer.TaskDefinition
        local function builder()
          local file = vim.fn.expand("%:p")
          local cmd = filetype_to_cmd[vim.bo.filetype](file)
          local components = {
            "shell_hook.interactive",
            "on_exit_set_status",
            "on_complete_notify",
          }
          if run_in_foreground then table.insert(components, { "open_output", direction = direction, focus = true }) end
          local task = {
            cmd = cmd,
            components = components,
            strategy = {
              "jobstart",
              use_terminal = true,
            },
          }
          return task
        end

        return builder
      end
      require("overseer").setup(opts)
      vim.tbl_map(require("overseer").register_template, {
        {
          name = "run file in background",
          builder = create_builder(false),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file in background",
        },
        {
          name = "run file",
          builder = create_builder(true, "float"),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file",
        },
        {
          name = "run file in new tab",
          builder = create_builder(true, "tab"),
          condition = {
            filetype = vim.tbl_keys(filetype_to_cmd),
          },
          desc = "Run single file in a new tab",
        },
        {
          name = "run file in horizontal split",
          builder = create_builder(true, "horizontal"),
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
              components = {
                "shell_hook.interactive",
                "on_exit_set_status",
                { "open_output", direction = "tab", focus = true },
              },
              strategy = { "jobstart", use_terminal = true },
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
              components = { "shell_hook.interactive", "on_exit_set_status", "on_complete_notify" },
              args = { "-m", python_module },
              env = { PYTHONPATH = "src" .. ":" .. vim.uv.cwd() },
              strategy = { "jobstart", use_terminal = true },
            }
          end,
          condition = { filetype = "python" },
          desc = "Run with `-m` flag",
        },
        {
          name = "uv virtualenv",
          desc = "Setup uv environment for project",
          components = { "shell_hook.interactive", "on_exit_set_status", "on_complete_notify" },
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
              components = { "shell_hook.interactive", "on_exit_set_status", "on_complete_notify" },
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
              components = { "shell_hook.interactive", "on_exit_set_status", "on_complete_notify" },
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
      })
    end,
  },
  {
    "nvim-neotest/neotest",
    optional = true,
  },
}
