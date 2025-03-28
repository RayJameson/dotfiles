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
        mouse = "",
        tabstop = 4,
        guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor",
        softtabstop = 4,
        shiftwidth = 4,
        foldlevelstart = 99,
        foldenable = true,
        foldmethod = "manual",
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
  },
}
