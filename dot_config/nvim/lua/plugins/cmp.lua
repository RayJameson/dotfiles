---@type LazySpec
return {
  "hrsh7th/nvim-cmp",
  optional = true,
  keys = { ":", "/", "?" }, -- lazy load cmp on more keys along with insert mode
  dependencies = {
    { "hrsh7th/cmp-cmdline", lazy = true },
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
      if entry and entry.source.name == "nvim_lsp" then
        vim_item.menu = ("[%s]"):format(entry.source.source.client.name)
      end
      vim_item = formatter(entry, vim_item)
      return vim_item
    end
    local any_word = [[\k\+]]
    local cmp = require("cmp")
    local cmdline_mapping = cmp.mapping.preset.cmdline {
      ["<C-y>"] = { c = cmp.mapping.confirm { select = true } },
    }
    cmp.setup.cmdline("/", {
      mapping = cmdline_mapping,
      sources = {
        {
          name = "buffer",
          keyword_length = 4,
          option = { keyword_pattern = any_word },
        },
      },
    })
    cmp.setup.cmdline(":", {
      mapping = cmdline_mapping,
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
    opts.mapping["<C-y>"] = cmp.mapping(cmp.mapping.confirm { select = true }, { "i", "c" })
    opts.mapping["<M-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" })
    opts.mapping["<C-x><C-o>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" })
    return opts
  end,
  specs = {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      opts.capabilities = cmp_nvim_lsp.default_capabilities()
    end,
  },
}
