---@type LazySpec
return {
  "cbochs/grapple.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "Grapple" },
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
        if opts.mappings == nil then opts.mappings = {} end
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
        maps.n["<C-n>"] = { "<Cmd>Grapple cycle forward<CR>", desc = "Select next tag" }
        maps.n["<C-p>"] = { "<Cmd>Grapple cycle backward<CR>", desc = "Select previous tag" }
      end,
    },
  },
}
