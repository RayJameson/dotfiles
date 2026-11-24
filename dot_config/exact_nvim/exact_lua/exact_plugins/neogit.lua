local prefix = "<Leader>g"
---@type LazySpec
return {
  "NeogitOrg/neogit",
  cmd = "Neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "AstroNvim/astroui", opts = { icons = { Neogit = "󰰔" } } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        maps.n[prefix .. "n"] = { desc = require("astroui").get_icon("Neogit", 1, true) .. "Neogit" }
        maps.n[prefix .. "nt"] = { "<Cmd>Neogit<CR>", desc = "Open Neogit Tab Page" }
        maps.n[prefix .. "nc"] = { "<Cmd>Neogit commit<CR>", desc = "Open Neogit Commit Page" }
        maps.n[prefix .. "nd"] = { ":Neogit cwd=", desc = "Open Neogit Override CWD" }
        maps.n[prefix .. "nk"] = { ":Neogit kind=", desc = "Open Neogit Override Kind" }
        maps.n[prefix .. "nf"] = { "<Cmd>Neogit kind=floating<CR>", desc = "Open Neogit Float" }
        maps.n[prefix .. "nh"] = { "<Cmd>Neogit kind=split<CR>", desc = "Open Neogit Horizontal Split" }
        maps.n[prefix .. "nv"] = { "<Cmd>Neogit kind=vsplit<CR>", desc = "Open Neogit Vertical Split" }
      end,
    },
  },
  opts = {
    disable_builtin_notifications = true, -- noice + snacks.notifier handle notifications
    disable_signs = true,
    integrations = { snacks = true },
    sections = { recent = { folded = false } },
  },
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      callback = function(ev)
        local patch = require("neogit_move_to_index")
        local function map(mode, lhs, fn, desc) vim.keymap.set(mode, lhs, fn, { buffer = ev.buf, desc = desc }) end
        map("n", "<LocalLeader>s", function() patch.toggle(false) end, "Toggle line/hunk/file in patch")
        map("x", "<LocalLeader>s", function() patch.toggle(true) end, "Toggle selected lines in patch")
        map("n", "<LocalLeader>i", function() patch.move_to_index(false) end, "Move patch (or change under cursor) into index")
        map("x", "<LocalLeader>i", function() patch.move_to_index(true) end, "Move selected lines into index")
        map("n", "<LocalLeader>c", patch.clear, "Clear patch selection")
        -- Reopening the same commit re-renders the buffer; redraw the marks.
        vim.schedule(patch.highlight)
      end,
    })
  end,
}
