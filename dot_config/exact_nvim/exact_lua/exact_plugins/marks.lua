---@type LazySpec
return {
  "chentoast/marks.nvim",
  event = "User AstroFile",
  opts = {
    excluded_filetypes = {
      "qf",
      "NvimTree",
      "toggleterm",
      "TelescopePrompt",
      "alpha",
      "netrw",
      "neo-tree",
      "oil",
      "noice",
    },
  },
  config = function(_, opts)
    opts.mappings = opts.mappings or {}
    for i = 0, 9 do
      opts.mappings["set_bookmark" .. i] = false
      opts["bookmark_" .. i] = { sign = tostring(i) }
    end
    local marks = require "marks"
    marks.setup(opts)
    local bs = marks.bookmark_state

    -- read the 2nd key ourselves so m1 / '1 behave the same however slowly they're typed
    local function digit_or(prefix, on_digit)
      return function()
        local ok, c = pcall(vim.fn.getcharstr)
        if not ok then return end
        local n = #c == 1 and tonumber(c)
        if n then
          on_digit(n)
        else
          vim.api.nvim_feedkeys(prefix .. c, "in", false)
        end
      end
    end

    vim.keymap.set("n", "m", digit_or("m", function(n)
      bs:delete_all(n)
      bs:place_mark(n)
    end), { desc = "Set mark" })
    for _, k in ipairs { "'", "`" } do
      vim.keymap.set("n", k, digit_or(k, function(n) bs:next(n) end), { desc = "Jump to mark" })
    end
  end,
}
