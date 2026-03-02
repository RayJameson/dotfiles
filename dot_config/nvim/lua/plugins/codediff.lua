local function get_default_branch()
  for _, origin in ipairs { "origin/main", "origin/master" } do
    if require("astrocore").cmd({ "git", "rev-parse", "--verify", origin }, false) then return origin end
  end
  vim.notify("Unable to identify an origin branch", vim.log.levels.WARN)
end

return {
  "esmuellert/codediff.nvim",
  event = "User AstroGitFile",
  cmd = "CodeDiff",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    explorer = { view_mode = "tree" },
    diff = {
      hide_merge_artifacts = true,
      jump_to_first_change = false,
    },
  },
  specs = {
    {
      "AstroNvim/astroui",
      ---@type AstroUIOpts
      opts = { icons = { Diff = "" } },
    },
    {
      "NeogitOrg/neogit",
      optional = true,
      opts = {
        integrations = {
          codediff = true,
        },
        diff_viewer = "codediff",
      },
    },
    {
      "AstroNvim/astrocore",
      ---@param opts AstroCoreOpts
      opts = function(_, opts)
        if opts.mappings == nil then opts.mappings = { n = {} } end
        local maps, prefix = opts.mappings, "<leader>D" ---@cast maps -nil
        maps.n[prefix] = { desc = require("astroui").get_icon("Diff", 1, true) .. "CodeDiff" }
        maps.n[prefix .. "<CR>"] = {
          function() vim.cmd.CodeDiff() end,
          desc = "Open CodeDiff",
        }
        maps.n[prefix .. "f"] = {
          function() vim.cmd.CodeDiff("history", "%") end,
          desc = "Open file diff history",
        }
        maps.n[prefix .. "b"] = {
          function()
            local branch = get_default_branch()
            if branch then vim.cmd.CodeDiff("history", branch .. "..HEAD") end
          end,
          desc = "Open CodeDiff branch history",
        }
        maps.n[prefix .. "o"] = {
          function()
            local branch = get_default_branch()
            if branch then vim.cmd.CodeDiff(branch) end
          end,
          desc = "Open CodeDiff origin branch history",
        }
        maps.x[prefix] = {
          function()
            local start_line = vim.fn.getpos("v")[2]
            local end_line = vim.fn.getpos(".")[2]
            vim.cmd.CodeDiff { "history", range = { start_line, end_line } }
          end,
          desc = "Open CodeDiff line(s) history",
        }
        -- simulate DiffView jump to first entry in history
        opts.autocmds.CodeView = {
          {
            event = "User",
            pattern = "CodeDiffOpen",
            callback = function(args)
              if args.data.mode == "history" then
                vim.defer_fn(function() require("codediff").next_file() end, 20)
              end
            end,
          },
        }
      end,
    },
  },
}
