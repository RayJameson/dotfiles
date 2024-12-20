---@type LazySpec
return {
  -- override nvim-cmp plugin
  "iguanacucumber/magazine.nvim",
  name = "nvim-cmp",
  optional = true,
  keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
  dependencies = {
    { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
    { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
    { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
    { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    ---@diagnostic disable-next-line: missing-fields
    opts.performance = {
      debounce = 0,
      throttle = 0,
    }
    local formatter = opts.formatting.format
    opts.formatting.format = function(entry, vim_item)
      -- your before function, just goes here
      local sources_map = {
        buffer = "Buffer",
        path = "Path",
        cmdline = "Cmdline",
        nvim_lsp = "LSP",
        luasnip = "LuaSnip",
        nvim_lua = "Lua",
        latex_symbols = "Latex",
        orgmode = "Org",
        noice_popupmenu = "Noice",
      }
      if entry and entry.source.name == "nvim_lsp" then
        vim_item.menu = ("[%s] - [%s]"):format(sources_map[entry.source.name], entry.source.source.client.name)
      elseif sources_map[entry.source.name] then
        vim_item.menu = ("[%s]"):format(sources_map[entry.source.name])
      else
        vim_item.menu = ("[%s]"):format(entry.source.name)
      end

      -- save the kind text
      local kind_text = vim_item.kind
      -- run the default formatter
      assert(formatter)
      vim_item = formatter(entry, vim_item)
      -- add the kind text after the symbol
      vim_item.kind = (vim_item.kind or "") .. " " .. kind_text

      -- return vim_item
      return vim_item
    end
    local any_word = [[\k\+]]
    local cmp = require("cmp")
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        {
          name = "buffer",
          keyword_length = 4,
          option = { keyword_pattern = any_word },
        },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        {
          name = "path",
          priority = 300,
        },
        {
          name = "cmdline",
          priority = 750,
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      },
    })
    opts.mapping["<M-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" })
    opts.mapping["<C-x><C-o>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" })
    return opts
  end,
}
