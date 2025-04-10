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
  },
  opts = {
    request = {
      hooks = {
        user_agent = "Mozilla/5.0 (U; Linux x86_64) AppleWebKit/533.48 (KHTML, like Gecko) Chrome/55.0.1978.323 Safari/600",
      },
    },
  },
  config = function(_, opts) vim.g.rest_nvim = require("astrocore").extend_tbl(opts, vim.g.rest_nvim) end,
}
