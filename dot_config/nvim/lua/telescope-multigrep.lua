--[[
Original script by Teej: https://github.com/tjdevries/config.nvim/blob/master/lua/custom/telescope/multi-ripgrep.lua
Check out his video about it: https://youtu.be/xdXE1tOT-qg?si=Xth0TdyYyu7qvnmy

This is a bit modified version of the script
* removed deprecated api call
* changed shortcuts for my use
* module-like structure instead of function return
* option to search in hidden/ignored files
* option to change prompt title
--]]

local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")

local M = {}

---@class MultiGrepOpts
---@field cwd? string
---@field shortcuts? { [string]: string}
---@field pattern? string
---@field all_files? boolean
---@field prompt_title? string

---@param opts? MultiGrepOpts
M.search = function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or (vim.uv.cwd() or vim.loop.cwd())
  opts.shortcuts = vim.tbl_deep_extend("force", {
    ["l"] = "*.lua",
    ["v"] = "*.vim",
    ["r"] = "*.rs",
    ["g"] = "*.go",
    ["p"] = "*.py",
    ["j"] = "*.json",
    ["y"] = "*.{yml,yaml}",
  }, opts.shortcuts or {})
  opts.prompt_title = opts.prompt_title or "Live Grep (with shortcuts)"
  opts.pattern = opts.pattern or "%s"

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then return nil end

      local prompt_split = vim.split(prompt, "  ")

      local args = { "rg" }
      if opts.all_files then vim.list_extend(args, { "--hidden", "--no-ignore" }) end
      if prompt_split[1] then vim.list_extend(args, { "-e", prompt_split[1] }) end

      if prompt_split[2] then
        table.insert(args, "-g")

        local pattern
        if opts.shortcuts[prompt_split[2]] then
          pattern = opts.shortcuts[prompt_split[2]]
        else
          pattern = prompt_split[2]
        end

        table.insert(args, string.format(opts.pattern, pattern))
      end

      return vim
        .iter({
          args,
          { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
        })
        :flatten()
        :totable()
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = opts.prompt_title,
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end

return M
