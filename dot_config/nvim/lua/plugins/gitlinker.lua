---@type LazySpec
return {
  "linrongbin16/gitlinker.nvim",
  opts = function(_, _)
    return {
      router = {
        browse = {
          ["^github%..*%.com"] = require("gitlinker.routers").github_browse,
        },
        blame = {
          ["^github%..*%.com"] = require("gitlinker.routers").github_blame,
        },
      },
    }
  end,
  cmd = "GitLink",
  specs = {
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        if opts.mappings == nil then opts.mappings = { n = {}, x = {} } end
        local maps, prefix = opts.mappings, "<Leader>g" ---@cast maps -nil
        local icon = require("astroui").get_icon("Git", 1, true)
        maps.n[prefix] = { desc = icon .. "Git" }
        maps.x[prefix] = { desc = icon .. "Git" }
        for _, mode in pairs { "n", "x" } do
          maps[mode][prefix .. "o"] =
            { function() vim.cmd.GitLink { bang = true } end, desc = "Open git line(s) in web" }
          maps[mode][prefix .. "O"] = { function() vim.cmd.GitLink() end, desc = "Copy git line(s) url" }
        end
      end,
    },
  },
}
