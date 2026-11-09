---@type LazySpec
return {
  "rest-nvim/rest.nvim",
  ft = { "http" },
  init = function()
    vim.g.rest_nvim = {
      custom_dynamic_variables = {
        ["$timestamp_ms"] = function() return tostring(math.floor(os.time() * 1000)) end,
        ["$current_dttm"] = function() return os.date("%Y-%m-%d %H:%M:%S.000000") end,
      },
    }
    -- plugin's help advertises `q` to close the result pane but never maps it
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "rest_nvim_result",
      callback = function(args)
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = args.buf, desc = "Close result pane" })
      end,
    })
  end,
  keys = {
    { ",s", "<cmd>Rest run<cr>", ft = "http", desc = "Send request" },
    { ",r", "<cmd>Rest last<cr>", ft = "http", desc = "Replay last request" },
    { ",o", "<cmd>Rest open<cr>", ft = "http", desc = "Open result pane" },
    { ",e", "<cmd>Rest env select<cr>", ft = "http", desc = "Select .env file" },
  },
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        if opts.ensure_installed ~= "all" then
          opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, { "http" })
        end
      end,
    },
  },
}
