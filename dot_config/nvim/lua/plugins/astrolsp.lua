---@type LazySpec
return {
  { import = "plugins.lsp.config" },
  {
    "AstroNvim/astrolsp",
    opts = function(
      _,
      opts --[[@as AstroLSPOpts]]
    )
      local extend_tbl = require("astrocore").extend_tbl
      local maps = opts.mappings
      maps.n.gy = false
      maps.n.gr = { function() vim.lsp.buf.references() end, desc = "LSP references" }
      maps.n.go = { function() vim.lsp.buf.incoming_calls() end, desc = "LSP incoming calls" }
      maps.n.gO = { function() vim.lsp.buf.outgoing_calls() end, desc = "LSP outgoing calls" }
      if maps.n["<Leader>lG"] then maps.n["<Leader>lG"][1] = function() vim.lsp.buf.workspace_symbol() end end
      if maps.n.gd then maps.n.gd[1] = function() vim.lsp.buf.definition() end end
      if maps.n.gD then maps.n.gD = false end
      if maps.n.gI then maps.n.gI[1] = function() vim.lsp.buf.implementation() end end
      maps.n["<Leader>lI"] = { function() vim.lsp.buf.implementation() end, desc = "LSP implementations" }
      maps.n["<Leader>lt"] = { function() vim.lsp.buf.type_definition() end, desc = "LSP type definition" }
      maps.n["<Leader>li"] = { function() vim.lsp.buf.incoming_calls() end, desc = "LSP incoming calls" }
      maps.n["<Leader>lo"] = { function() vim.lsp.buf.outgoing_calls() end, desc = "LSP outgoing calls" }
      maps.n["<Leader>ls"] = {
        function()
          local aerial_avail, aerial = pcall(require, "aerial")
          if aerial_avail and aerial.snacks_picker then
            aerial.snacks_picker { layout = "right" }
          else
            require("snacks").picker.lsp_symbols()
          end
        end,
        desc = "Search symbols",
      }
      -- Configuration table of features provided by AstroLSP
      opts.features = extend_tbl(opts.features, {
        autoformat = false, -- enable or disable auto formatting on start
        codelens = true, -- enable/disable codelens refresh on start
        inlay_hints = true, -- enable/disable inlay hints on start
        semantic_tokens = true, -- enable/disable semantic token highlighting
        signature_help = true,
      })
      -- customize lsp formatting options
      opts.formatting.format_on_save = extend_tbl(opts.formatting.format_on_save, {
        -- control auto formatting on save
        enabled = false, -- enable or disable format on save globally
      })
      opts.formatting.disabled = true -- formatting is handled by conform.nvim
      opts.formatting.timeout_ms = 1000 -- default format timeout
      -- enable servers that you already have installed without mason
      opts.servers = opts.servers or {}
      opts.on_attach = function(client, bufnr)
        if vim.b[bufnr].large_buf then client.stop() end
      end
    end,
  },
}
