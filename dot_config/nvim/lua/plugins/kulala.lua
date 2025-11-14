---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  ft = { "http" },
  opts = {
    additional_curl_options = { "-L" },
    ui = {
      win_opts = {
        width = 105,
      },
    },
    global_keymaps = true,
    global_keymaps_prefix = ",",
    timeout = 15,
    icons = {
      inlay = {
        loading = "⏳",
        done = "✓ ",
        error = "❌",
      },
    },
    custom_dynamic_variables = {
      timestamp_ms = function() return tostring(math.floor(os.time() * 1000)) end,
      current_dttm = function() return os.date("%Y-%m-%d %H:%M:%S.000000") end,
    },
  },
  specs = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      if opts.ensure_installed then table.insert(opts.ensure_installed, "kulala-fmt") end
    end,
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
