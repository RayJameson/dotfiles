---@param lk gitlinker.Linker
local function gerrit_browse(lk)
  -- host
  local builder = "https://" .. lk.host  .. "/gitweb?p="
  -- org
  builder = builder .. (string.len(lk.org) > 0 and string.format("%s/", lk.org) or "")
  -- repo
  builder = builder .. string.format("%s.git;a=blob;", lk.repo)
  -- file
  builder = builder .. string.format("f=%s;", lk.file)
  -- line number
  builder = builder .. string.format("#l%d", lk.lstart)
  return builder
end

---@type LazySpec
return {
  "linrongbin16/gitlinker.nvim",
  opts = function(_, _)
    return {
      router = {
        browse = {
          ["^github%..*%.com"] = function(lk) require("gitlinker.routers").github_browse(lk) end,
          ["^gerrit%..*%.ru"] = gerrit_browse,
        },
        blame = {
          ["^github%..*%.com"] = function(lk) require("gitlinker.routers").github_blame(lk) end,
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
