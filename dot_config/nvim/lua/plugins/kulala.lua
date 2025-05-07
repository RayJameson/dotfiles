---@type LazySpec
return {
  "mistweaverco/kulala.nvim",
  ft = { "http" },
  opts = {
    additional_curl_options = {
      "-L",
      "-A",
      "Mozilla/5.0 (U; Linux x86_64) AppleWebKit/533.48 (KHTML, like Gecko) Chrome/55.0.1978.323 Safari/600",
    },
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
}
