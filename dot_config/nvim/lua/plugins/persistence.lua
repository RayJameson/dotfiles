---@type LazySpec
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {},
  specs = {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = { icons = { Persistence = "" } },
    },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        if not opts.mappings then opts.mappings = require("astrocore").empty_map_table() end
        local maps, prefix = opts.mappings, "<Leader>S"
        local icon = require("astroui").get_icon("Persistence", 1, true)
        assert(maps ~= nil)

        maps.n[prefix] = { desc = icon .. "Sessions" }
        maps.n[prefix .. "c"] = {
          function() require("persistence").load() end,
          desc = "Load session for cwd",
        }
        maps.n[prefix .. "s"] = {
          function() require("persistence").select() end,
          desc = "Select session to load",
        }
        maps.n[prefix .. "l"] = {
          function() require("persistence").load { last = true } end,
          desc = "Load the last session",
        }
        maps.n[prefix .. "d"] = {
          function() require("persistence").stop() end,
          desc = "Don't save session on exit",
        }
      end,
    },
  },
}
