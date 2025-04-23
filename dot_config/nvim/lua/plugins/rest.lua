---@type LazySpec
return {
  "rest-nvim/rest.nvim",
  ft = "http",
  cmd = "Rest",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "http" })
      end
    end,
  },
  specs = {
    {
      "AstroNvim/astrocore",
      ---@type AstroCoreOpts
      opts = {
        autocmds = {
          RestLocalMappings = {
            {
              event = "FileType",
              pattern = "http",
              callback = function(args)
                local prefix = "<LocalLeader>"
                require("astrocore").set_mappings({
                  n = {
                    [prefix .. "r"] = { "<Cmd>Rest run<CR>", desc = "Send request" },
                    [prefix .. "o"] = { "<Cmd>Rest open<CR>", desc = "Open result pane" },
                    [prefix .. "c"] = { "<Cmd>Rest curl yank<CR>", desc = "Yank curl to clipboard" },
                    [prefix .. "C"] = { "<Cmd>Rest cookies<CR>", desc = "Edit cookies file" },
                    [prefix .. "e"] = { "<Cmd>Rest env show<CR>", desc = "Show currently used .env file" },
                    [prefix .. "s"] = { "<Cmd>Rest env select<CR>", desc = "Select .env file to use" },
                  },
                }, { buffer = args.buf })
              end,
            },
          },
        },
      },
    },
    {
      "rebelot/heirline.nvim",
      optional = true,
      dependencies = {
        "AstroNvim/astroui",
        opts = { status = { statusline = { enabled = { filetype = { "^http$" } } } } },
      },
      opts = function(_, opts)
        if opts.statusline then
          local status = require("astroui.status")
          table.insert(opts.statusline, 10, {
            condition = function(self) return status.condition.buffer_matches({ filetype = "^http$" }, self.bufnr) end,
            status.component.fill { hl = { bg = "winbar_bg" } },
            {
              condition = function() return vim.b._rest_nvim_env_file ~= nil end,
              status.component.builder {
                { provider = "" },
                { provider = function() return vim.fn.fnamemodify(vim.b._rest_nvim_env_file, ":t") end },
                hl = { fg = "orange" },
              },
            },
          })
        end
      end,
    },
  },
  opts = {
    custom_dynamic_variables = {
      timestamp = function() return tostring(math.floor(os.time())) end,
      timestamp_ms = function() return tostring(math.floor(os.time() * 1000)) end,
      current_dttm = function() return os.date("%Y-%m-%d %H:%M:%S.000000") end,
    },
    request = {
      hooks = {
        user_agent = "Mozilla/5.0 (U; Linux x86_64) AppleWebKit/533.48 (KHTML, like Gecko) Chrome/55.0.1978.323 Safari/600",
      },
    },
  },
  config = function(_, opts) vim.g.rest_nvim = require("astrocore").extend_tbl(opts, vim.g.rest_nvim) end,
}
