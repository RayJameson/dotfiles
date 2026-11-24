---@type LazySpec
return {
  "cbochs/grapple.nvim",
  cmd = { "Grapple" },
  -- load early only in projects that already have tags, so the statusline indicator shows up
  event = function()
    local root = vim.fs.root(vim.fn.getcwd(), ".git") or vim.fn.getcwd()
    local name = root:gsub("[^%w]", function(c) return ("%%%02X"):format(c:byte()) end)
    if vim.uv.fs_stat(vim.fn.stdpath "data" .. "/grapple/" .. name .. ".json") then return { "VeryLazy" } end
  end,
  opts = { scope = "git", win_opts = { border = "rounded" } },
  specs = {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = { icons = { Grapple = "󰛢" } },
    },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        if opts.mappings == nil then opts.mappings = { n = {} } end
        local maps, prefix = opts.mappings, "<Leader><Leader>" ---@cast maps -nil
        maps.n[prefix] = { desc = require("astroui").get_icon("Grapple", 1, true) .. "Grapple" }
        maps.n[prefix .. "e"] = { "<Cmd>Grapple toggle_tags<CR>", desc = "Select from tags" }
        maps.n[prefix .. "t"] = {
          function()
            require("grapple").toggle()
            vim.cmd.redrawstatus()
          end,
          desc = "Toggle a file",
        }
        maps.n[prefix .. "s"] = {
          "<Cmd>Grapple toggle_scopes<CR>",
          desc = "Switch scope",
        }
        maps.n[prefix .. "l"] = {
          "<Cmd>Grapple toggle_loaded<CR>",
          desc = "Toggle loaded scopes",
        }
        maps.n[prefix .. "w"] = {
          function()
            local tags = require("grapple").tags() or {}
            if #tags == 0 then return vim.notify("No Grapple tags", vim.log.levels.WARN) end
            require("snacks").picker.grep { dirs = vim.tbl_map(function(t) return t.path end, tags) }
          end,
          desc = "Words in tagged files",
        }
        maps.n["<C-n>"] = { "<Cmd>Grapple cycle forward<CR>", desc = "Select next tag" }
        maps.n["<C-p>"] = { "<Cmd>Grapple cycle backward<CR>", desc = "Select previous tag" }
      end,
    },
  },
}
