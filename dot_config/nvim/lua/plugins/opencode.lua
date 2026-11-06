local term_opts = { win = { position = "right", enter = false } }

---@type LazySpec
return {
  "nickjvandyke/opencode.nvim",
  dependencies = { "folke/snacks.nvim" },
  ---@type opencode.Opts
  opts = {
    server = {
      start = function() require("snacks.terminal").open("opencode", term_opts) end,
    },
  },
  config = function(_, opts) vim.g.opencode_opts = opts end,
  specs = {
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        local maps, prefix = assert(opts.mappings), "<Leader>O"
        local icon = require("astroui").get_icon("OpenCode", 1, true)
        for _, mode in ipairs { "n", "x" } do
          maps[mode][prefix] = { desc = icon .. "OpenCode" }
          maps[mode][prefix .. "a"] = { function() require("opencode").ask "@this: " end, desc = "Ask about this" }
          maps[mode][prefix .. "+"] = { function() require("opencode").ask "@this " end, desc = "Add this to prompt" }
          maps[mode][prefix .. "e"] = {
            function() require("opencode").prompt "Explain @this and its context" end,
            desc = "Explain this",
          }
          maps[mode][prefix .. "s"] = { function() require("opencode").select() end, desc = "Select prompt" }
          maps[mode][prefix .. "o"] = {
            function() return require("opencode").operator "@this " end,
            expr = true,
            desc = "Send range to OpenCode",
          }
        end
        maps.n[prefix .. "t"] = {
          function()
            local term, created =
              require("snacks.terminal").get("opencode", vim.tbl_deep_extend("force", term_opts, { win = { enter = true } }))
            if created or not term then return end
            if term:valid() then
              term:hide()
            else
              term:show():focus()
            end
          end,
          desc = "Toggle OpenCode",
        }
        maps.n[prefix .. "b"] = { function() require("opencode").ask "@buffer " end, desc = "Add buffer to prompt" }
        maps.n[prefix .. "d"] = { function() require("opencode").prompt "Fix @diagnostics" end, desc = "Fix diagnostics" }
      end,
    },
    { "AstroNvim/astroui", opts = { icons = { OpenCode = "" } } },
  },
}
