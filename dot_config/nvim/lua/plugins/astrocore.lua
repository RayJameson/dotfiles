---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      highlighturl = true, -- highlight URLs at start
      diagnostics = true,
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    ---@type vim.diagnostics.Opts.VirtualText
    diagnostics = {
      underline = false,
      update_in_insert = false,
    },
    -- vim options can be configured here
    options = {
      opt = {
        -- set to true or false etc.
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        wrap = false, -- sets vim.opt.wrap
        showtabline = 0,
        -- set to true or false etc.
        signcolumn = "auto:2", -- sets vim.opt.signcolumn to auto
        swapfile = false,
        colorcolumn = "120",
        foldcolumn = "auto:1",
        mouse = "",
        tabstop = 4,
        guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor",
        softtabstop = 4,
        shiftwidth = 4,
        foldenable = true,
        smarttab = true,
        clipboard = "",
        autoindent = true,
        smartindent = true,
        autochdir = false,
        list = true,
        showbreak = "↪ ",
        timeoutlen = 300,
        title = true,
        titlestring = "%<%F%=%l/%L - nvim",
        listchars = {
          tab = "→ ",
          nbsp = "␣",
          trail = "•",
          extends = "⟩",
          precedes = "⟨",
        },
        fillchars = {
          eob = " ",
          fold = " ",
          foldopen = "",
          foldclose = "",
        },
      },
      g = { -- vim.g.<key>
        loaded_perl_provider = false,
        loaded_ruby_provider = false,
        loaded_node_provider = false,
        loaded_python3_provider = false,
        rustaceanvim = {
          tools = {
            float_win_config = {
              border = "rounded",
            },
          },
        },
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    autocmds = {
      bufferline = false,
      JsonFormatprg = {
        {
          event = "FileType",
          pattern = "json",
          callback = function() vim.opt_local.formatprg = vim.fn.executable("jq") == 1 and "jq" or "" end,
        },
      },
      RememberFolds = {
        {
          event = "BufWinLeave",
          pattern = "?*",
          callback = function(args)
            if require("astrocore.buffer").is_valid(args.buf) then
              vim.cmd { cmd = "mkview", mods = { silent = true } }
            end
          end,
        },
        {
          event = "BufWinEnter",
          pattern = "?*",
          callback = function(args)
            if require("astrocore.buffer").is_valid(args.buf) then
              vim.cmd { cmd = "loadview", mods = { silent = true } }
            end
          end,
        },
      },
      TermNumbers = {
        {
          event = "TermOpen",
          callback = function()
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.foldcolumn = "0"
            vim.opt_local.signcolumn = "no"
          end,
        },
      },
      RelativeNumberSwitch = {
        {
          event = "InsertEnter",
          callback = function()
            if vim.wo.relativenumber then
              vim.wo.relativenumber = false
              vim.w.adaptive_relative_number_state = true
            end
          end,
        },
        {
          event = "InsertLeave",
          callback = function()
            if vim.w.adaptive_relative_number_state then
              vim.wo.relativenumber = true
              vim.w.adaptive_relative_number_state = nil
            end
          end,
        },
      },
      QuickFix = {
        {
          event = "FileType",
          pattern = "qf",
          callback = function()
            vim.opt_local.colorcolumn = ""
            vim.opt_local.signcolumn = "auto:9"
            vim.opt_local.relativenumber = true
            vim.opt_local.list = false
          end,
        },
      },
      DynamicColorColumn = {
        {
          event = "FileType",
          pattern = { "markdown", "dockerfile", "make", "http" },
          callback = function() vim.opt_local.colorcolumn = "" end,
        },
        {
          event = "FileType",
          pattern = "gitcommit",
          callback = function() vim.opt_local.colorcolumn = "71" end,
        },
      },
      FileSceletons = (function()
        local result = {}
        for file_extension, command in pairs {
          sh = "bash",
          zsh = "zsh",
          fish = "fish",
          ksh = "ksh",
          awk = "awk",
        } do
          table.insert(result, {
            event = "BufNewFile",
            pattern = "*." .. file_extension,
            callback = function()
              vim.api.nvim_buf_set_lines(0, 0, 0, true, {
                "#!/usr/bin/env " .. command,
              })
            end,
          })
        end
        return result
      end)(),
      HelpPages = {
        {
          event = "BufEnter",
          callback = function(args)
            if vim.bo[args.buf].buftype == "help" or vim.bo[args.buf].filetype == "man" then
              vim.cmd.wincmd { "T", mods = { silent = true } }
            end
          end,
        },
      },
    },
  },
}
