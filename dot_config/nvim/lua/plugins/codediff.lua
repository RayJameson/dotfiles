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
    explorer = {
      width = 25,
      view_mode = "tree",
    },
    history = {
      height = 10,
    },
    diff = {
      hide_merge_artifacts = true,
      jump_to_first_change = false,
    },
    keymaps = {
      conflict = {
        accept_incoming = "<LocalLeader>t", -- Accept incoming (theirs/left) change
        accept_current = "<LocalLeader>o", -- Accept current (ours/right) change
        accept_both = "<LocalLeader>b", -- Accept both changes (incoming first)
        discard = "<LocalLeader>x", -- Discard both, keep base
        accept_all_incoming = "<LocalLeader>T", -- Accept ALL incoming changes
        accept_all_current = "<LocalLeader>O", -- Accept ALL current changes
        accept_all_both = "<LocalLeader>B", -- Accept ALL both changes
        discard_all = "<LocalLeader>X", -- Discard ALL, reset to base
      },
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
        if opts.mappings == nil then opts.mappings = { n = {}, x = {} } end
        local maps, prefix = opts.mappings, "<leader>D" ---@cast maps -nil
        maps.n[prefix] = { desc = require("astroui").get_icon("Diff", 1, true) .. "CodeDiff" }
        maps.n[prefix .. "<CR>"] = {
          function() vim.cmd.CodeDiff() end,
          desc = "Explorer",
        }
        maps.n[prefix .. "f"] = {
          function() vim.cmd.CodeDiff("history", vim.fn.expand("%")) end,
          desc = "File history",
        }
        maps.n[prefix .. "b"] = {
          function()
            local branch = get_default_branch()
            if branch then vim.cmd.CodeDiff("history", branch .. "..HEAD") end
          end,
          desc = "Branch history",
        }
        maps.n[prefix .. "r"] = {
          function() vim.cmd.CodeDiff("history") end,
          desc = "Repo history",
        }
        maps.n[prefix .. "o"] = {
          function()
            local branch = get_default_branch()
            if branch then vim.cmd.CodeDiff(branch) end
          end,
          desc = "Origin branch history",
        }
        maps.x[prefix] = {
          function()
            local start_line = vim.fn.getpos("v")[2]
            local end_line = vim.fn.getpos(".")[2]
            vim.cmd.CodeDiff { "history", range = { start_line, end_line } }
          end,
          desc = "CodeDiff line(s) history",
        }
      end,
    },
  },
}
