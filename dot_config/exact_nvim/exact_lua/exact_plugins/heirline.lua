---@type LazySpec
return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require("astroui.status")
    -- custom heirline statusline component for grapple

    local function dap_ui_component()
      return {
        status.component.builder {
          condition = function() return package.loaded.dap and require("dap").session() ~= nil end,
          static = {
            symbols = {
              RUNNING = "",
              STOPPED = "",
            },
            colors = {
              RUNNING = require("colors").green_1,
              STOPPED = require("colors").red_6,
            },
          },
          provider = function(self)
            local mapped_debugger_status = require("dap").session().stopped_thread_id == nil and "RUNNING" or "STOPPED"
            return self.symbols[mapped_debugger_status]
          end,
          hl = function(self)
            local mapped_debugger_status = require("dap").session().stopped_thread_id == nil and "RUNNING" or "STOPPED"
            return { fg = self.colors[mapped_debugger_status] }
          end,
          update = {
            "User",
            pattern = "DapProgressUpdate",
            callback = vim.schedule_wrap(function() vim.cmd("redrawstatus") end),
          },
        },
      }
    end

    local function grapple()
      return status.component.builder {
        condition = function() return package.loaded.grapple and require("grapple").exists() end,
        { provider = " " },
        { provider = function() return require("grapple").statusline() end },
      }
    end
    local Spacer = { provider = " " }
    local function pad(child)
      return {
        condition = child.condition,
        Spacer,
        child,
        Spacer,
      }
    end

    -- local function active_venv()
    --   return status.component.builder {
    --     provider = status.provider.virtual_env {},
    --     surround = { separator = "right", color = "orange", condition = status.condition.has_virtual_env },
    --   }
    -- end
    local function OverseerTasksForStatus(status)
      return {
        condition = function(self) return self.tasks[status] end,
        provider = function(self) return string.format("%s%d", self.symbols[status], #self.tasks[status]) end,
        hl = function(self)
          return {
            fg = require("heirline.utils").get_highlight(string.format("Overseer%s", status)).fg,
          }
        end,
      }
    end
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

    local overseer = function()
      return status.component.builder {
        condition = function() return package.loaded.overseer end,
        init = function(self)
          local tasks = require("overseer.task_list").list_tasks { unique = true }
          local tasks_by_status = require("overseer.util").tbl_group_by(tasks, "status")
          self.tasks = tasks_by_status
        end,
        static = {
          symbols = {
            ["CANCELED"] = "󰜺 ",
            ["FAILURE"] = " ",
            ["SUCCESS"] = "󰸞 ",
            ["RUNNING"] = "󰑮 ",
          },
        },

        pad(OverseerTasksForStatus("CANCELED")),
        pad(OverseerTasksForStatus("RUNNING")),
        pad(OverseerTasksForStatus("SUCCESS")),
        pad(OverseerTasksForStatus("FAILURE")),
      }
    end
    local tabs_exists = function() return #vim.api.nvim_list_tabpages() >= 2 end
    local tabline = function()
      return status.component.builder {
        condition = tabs_exists,
        surround = { separator = "right", color = "winbar_bg", condition = tabs_exists },
        status.heirline.make_tablist { -- component for each tab
          provider = tabnr(),
          hl = function(self) return status.hl.get_attributes(status.heirline.tab_type(self, "tab"), true) end,
        },
      }
    end

    local condition = require("astroui.status.condition")
    local hl = require("astroui.status.hl")
    opts.statusline = {
      -- statusline
      hl = { fg = "fg", bg = "bg" },
      status.component.mode {
        surround = { separator = "none", color = hl.mode_bg, update = { "ModeChanged", pattern = "*:*" } },
      },
      grapple(),
      status.component.diagnostics(),
      overseer(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      dap_ui_component(),
      status.component.virtual_env {
        hl = { fg = "orange" },
        condition = function() return condition.has_virtual_env() and condition.buffer_matches { filetype = "python" } end,
      },
      status.component.lsp(),
      status.component.treesitter(),
      status.component.nav(),
    }
    opts.tabline = {}
    local path_func = status.provider.filename { modify = ":.:h", fallback = "" }
    opts.winbar = {
      -- store the current buffer number
      init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
      fallthrough = false, -- pick the correct winbar based on condition
      -- inactive winbar
      {
        condition = function() return not status.condition.is_active() end,
        -- show the path to the file relative to the working directory
        status.component.separated_path { path_func = path_func },
        -- add the file name and icon
        status.component.file_info {
          file_icon = { hl = status.hl.file_icon("winbar"), padding = { left = 0 } },
          filename = {},
          filetype = false,
          file_modified = false,
          file_read_only = false,
          hl = status.hl.get_attributes("winbarnc", true),
          surround = false,
          update = "BufEnter",
        },
      },
      -- active winbar
      {
        -- show the path to the file relative to the working directory
        status.component.separated_path { path_func = path_func },
        -- add the file name and icon
        status.component.file_info { -- add file_info to breadcrumbs
          file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
          filename = {},
          filetype = false,
          file_modified = { condition = condition.file_modified },
          file_read_only = { condition = condition.file_read_only },
          hl = status.hl.get_attributes("winbar", true),
          surround = false,
        },
        -- show the breadcrumbs
        status.component.breadcrumbs {
          icon = { hl = true },
          hl = status.hl.get_attributes("winbar", true),
          prefix = true,
          padding = { left = 0 },
        },
        status.component.fill { hl = { bg = "winbar_bg" } }, -- fill the rest of the tabline with background color
        status.component.git_diff {
          surround = { separator = "right", color = "winbar_bg", condition = condition.git_changed },
          on_click = false,
        },
        status.component.git_branch {
          on_click = false,
          surround = { separator = "right", color = "winbar_bg", condition = condition.is_git_repo },
        },
        tabline(),
      },
    }
    return opts
  end,
}
