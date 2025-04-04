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
                    [prefix .. "c"] = { "<Cmd>Rest cookies<CR>", desc = "Edit cookies file" },
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
  opts = {},
  config = function(_, opts) vim.g.rest_nvim = require("astrocore").extend_tbl(opts, vim.g.rest_nvim) end,
}
