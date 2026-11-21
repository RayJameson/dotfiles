---@type LazySpec
return {
  "NeogitOrg/neogit",
  optional = true,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "NeogitCommitView",
      callback = function(ev)
        local patch = require("neogit_move_to_index")
        local function map(mode, lhs, fn, desc) vim.keymap.set(mode, lhs, fn, { buffer = ev.buf, desc = desc }) end
        map("n", "<LocalLeader>s", function() patch.toggle(false) end, "Toggle line/hunk/file in patch")
        map("x", "<LocalLeader>s", function() patch.toggle(true) end, "Toggle selected lines in patch")
        map(
          "n",
          "<LocalLeader>i",
          function() patch.move_to_index(false) end,
          "Move patch (or change under cursor) into index"
        )
        map("x", "<LocalLeader>i", function() patch.move_to_index(true) end, "Move selected lines into index")
        map("n", "<LocalLeader>c", patch.clear, "Clear patch selection")
        -- Reopening the same commit re-renders the buffer; redraw the marks.
        vim.schedule(patch.highlight)
      end,
    })
  end,
}
