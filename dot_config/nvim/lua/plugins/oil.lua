---@type LazySpec
return {
  "stevearc/oil.nvim",
  specs = {
    {
      "rebelot/heirline.nvim",
      optional = true,
      dependencies = { "AstroNvim/astroui", opts = { status = { winbar = { enabled = { filetype = { "^oil$" } } } } } },
      opts = function(_, opts)
        local function tabnr()
          return function(self)
            if not self or not self.tabnr then return "" end
            if self.is_active then
              return "%" .. self.tabnr .. "T[" .. self.tabnr .. "]%T"
            else
              return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
            end
          end
        end
        if opts.winbar then
          local status = require("astroui.status")
          table.insert(opts.winbar, 1, {
            condition = function(self) return status.condition.buffer_matches({ filetype = "^oil$" }, self.bufnr) end,
            status.component.separated_path {
              padding = { left = 2 },
              max_depth = false,
              suffix = false,
              path_func = function(self) return require("oil").get_current_dir(self.bufnr) end,
            },
            status.component.fill { hl = { bg = "winbar_bg" } }, -- fill the rest of the tabline with background color
            { -- tab list
              condition = function() return #vim.api.nvim_list_tabpages() >= 2 end, -- only show tabs if there are more than one
              status.heirline.make_tablist { -- component for each tab
                provider = tabnr(),
                hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
              },
            },
          })
        end
      end,
    },
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<Leader>No"] = {
              function() require("oil").open( vim.env.HOME .. "/Obsidian/vault" ) end,
              desc = "Open notes directory",
            },
            ["-"] = { function() require("oil").open() end, desc = "Open parent directory" },
          },
        },
        autocmds = {
          oil_settings = {
            {
              event = "FileType",
              desc = "Disable view saving for oil buffers",
              pattern = "oil",
              callback = function(args) vim.b[args.buf].view_activated = false end,
            },
            {
              event = "User",
              pattern = "OilActionsPost",
              desc = "Close buffers when files are deleted in Oil",
              callback = function(args)
                if args.data.err then return end
                for _, action in ipairs(args.data.actions) do
                  if action.type == "delete" then
                    local _, path = require("oil.util").parse_url(action.url)
                    local bufnr = vim.fn.bufnr(path)
                    if bufnr ~= -1 then require("astrocore.buffer").wipe(bufnr, true) end
                  end
                end
              end,
            },
          },
        },
      },
    },
  },
  init = function()
    -- yoinked it from this comment
    -- https://github.com/folke/lazy.nvim/issues/533#issuecomment-1489174249
    if vim.fn.argc() == 1 then
      local stat = vim.loop.fs_stat(vim.fn.argv(0))
      -- Capture the protocol and lazy load oil if it is "oil-ssh", besides also lazy
      -- loading it when the first argument is a directory.
      local adapter = string.match(vim.fn.argv(0), "^([%l-]*)://")
      if (stat and stat.type == "directory") or adapter == "oil-ssh" then
        require("lazy").load { plugins = { "oil.nvim" } }
      end
    end
    if not package.loaded["oil"] then
      vim.api.nvim_create_augroup("oil_start", { clear = true })
      vim.api.nvim_create_autocmd("BufNew", {
        group = "oil_start",
        desc = "start oil when editing a directory",
        callback = function()
          if vim.fn.isdirectory(vim.fn.expand("<afile>")) == 1 then
            require("lazy").load { plugins = { "oil.nvim" } }
            -- Once oil is loaded, we can delete this autocmd
            return true
          end
        end,
      })
    end
  end,
  ---@diagnostic disable: missing-fields
  ---@type oil.Config
  opts = {
    skip_confirm_for_simple_edits = true,
    group = "oil_settings",
    preview_win = {
      preview_method = "fast_scratch",
    },
    columns = {
      "icon",
      "permissions",
    },
    view_options = {
      show_hidden = true,
    },
    delete_to_trash = false,
    watch_for_changes = true,
    lsp_file_methods = {
      enabled = true,
      timeout_ms = 3000,
      autosave_changes = "unmodified",
    },
    keymaps = {
      ["gx"] = {
        callback = function()
          local oil = require("oil")
          local cwd = oil.get_current_dir()
          local entry = oil.get_cursor_entry()
          if cwd and entry then require("astrocore").system_open(string.format("%s/%s", cwd, entry.name)) end
        end,
        desc = "Open file under cursor",
        nowait = true,
      },
      ["gy"] = {
        desc = "Copy the filepath of the entry under the cursor to the + register",
        callback = function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          local dir = oil.get_current_dir()
          if not entry or not dir then return end
          vim.fn.setreg("+", dir .. entry.name)
        end,
      },
      ["~"] = false,
    },
  },
}
