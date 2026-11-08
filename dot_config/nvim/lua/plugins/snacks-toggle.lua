---@diagnostic disable: missing-fields
---@type LazySpec
return {
  "folke/snacks.nvim",
  priority = 10000,
  optional = true,
  init = function()
    local toggle = require("snacks.toggle")
    toggle.option("signcolumn", { on = "auto:2", off = "no" }):map("<Leader>ug")
    toggle.option("wrap"):map("<Leader>uw")
    toggle.option("background", { name = "light theme", on = "light", off = "dark" }):map("<Leader>ub")
    toggle.option("conceallevel", { on = 2, off = 0, name = "conceal" }):map("<Leader>uS")
    toggle.option("showtabline", { on = 2, off = 0, name = "tabline" }):map("<Leader>ut")
    toggle.option("paste"):map("<Leader>up")
    toggle.option("lazyredraw"):map("<Leader>ur")
    toggle.option("spell", { name = "spellcheck" }):map("<Leader>us")
    toggle.option("sidescrolloff", { on = 999, off = 0, global = true }):map("<Leader>uO")
    toggle.option("scrolloff", { on = 999, off = 0, global = true }):map("<Leader>uo")
    toggle
      .new({
        name = "notifications",
        get = function() return require("astrocore").config.features.notifications end,
        set = function()
          local features = assert(require("astrocore").config.features)
          features.notifications = not features.notifications
        end,
      })
      :map("<Leader>uN")
    toggle
      .new({
        name = "autopairs",
        get = function()
          local autopairs = require("nvim-autopairs")
          return not autopairs.state.disabled
        end,
        set = function() require("nvim-autopairs").toggle() end,
      })
      :map("<Leader>ua")
    toggle
      .new({
        name = "rooter autochdir",
        get = function() return require("astrocore").config.rooter.autochdir end,
        set = function()
          local root_config = require("astrocore").config.rooter
          assert(root_config)
          root_config.autochdir = not root_config.autochdir
        end,
      })
      :map("<Leader>uA")
    toggle
      .new({
        name = "virtual lines",
        get = function() return vim.diagnostic.config().virtual_lines end,
        set = function() require("astrocore.toggles").virtual_lines(true) end,
      })
      :map("<Leader>uV")
    toggle
      .new({
        name = "virtual text",
        get = function() return vim.diagnostic.config().virtual_text end,
        set = function() require("astrocore.toggles").virtual_text(true) end,
      })
      :map("<Leader>uv")
    toggle
      .new({
        name = "syntax highlight",
        get = function() return vim.bo[vim.api.nvim_win_get_buf(0)].syntax ~= "off" end,
        set = function() require("astrocore.toggles").buffer_syntax(true) end,
      })
      :map("<Leader>uy")
    toggle
      .new({
        name = "URL highlight",
        get = function() return require("astrocore").config.features.highlighturl end,
        set = function()
          local features = assert(require("astrocore").config.features)
          features.highlighturl = not features.highlighturl
        end,
      })
      :map("<Leader>uu")
    toggle
      .new({
        name = "diagnostics",
        get = function() return vim.diagnostic.is_enabled() end,
        set = function(should_enable)
          if should_enable then
            vim.diagnostic.enable()
          else
            vim.diagnostic.enable(false)
          end
        end,
      })
      :map("<Leader>ud")
    toggle
      .new({
        name = "autocompletion (buffer)",
        get = function() return vim.b.completion or require("astrocore").config.features.cmp end,
        set = function() require("astrocore.toggles").buffer_cmp() end,
        notify = false,
      })
      :map("<Leader>uc")
    toggle
      .new({
        name = "autocompletion (global)",
        get = function() return require("astrocore").config.features.cmp end,
        set = function() require("astrocore.toggles").cmp() end,
        notify = false,
      })
      :map("<Leader>uC")
    toggle
      .new({
        name = "statusline",
        get = function() return vim.opt.laststatus:get() ~= 0 end,
        set = function() require("astrocore.toggles").statusline() end,
        notify = false,
      })
      :map("<Leader>ul")
    toggle
      .new({
        name = "color highlighting",
        get = function() return require("nvim-highlight-colors").is_active() end,
        set = function() require("nvim-highlight-colors").toggle() end,
      })
      :map("<Leader>uz")
    toggle.zen():map("<Leader>uZ")
    toggle.option("foldcolumn", { on = "auto:1", off = "0", global = false }):map("<Leader>u>")
    toggle.indent():map("<Leader>u|")
  end,
  specs = {
    "AstroNvim/astrolsp",
    ---@param opts AstroLSPOpts
    opts = function(_, opts)
      local old_on_attach = function(client, bufnr) end
      if opts.on_attach then old_on_attach = opts.on_attach end
      opts.on_attach = function(client, bufnr)
        local toggle = require("snacks.toggle")
        if client:supports_method("textDocument/codeLens") then
          toggle
            .new({
              name = "CodeLens",
              get = function() return require("astrolsp").config.features.codelens end,
              set = function() require("astrolsp.toggles").codelens() end,
              notify = false,
            })
            :map("<Leader>uL", { buffer = bufnr })
        end
        if client:supports_method("textDocument/signatureHelp") then
          toggle
            .new({
              name = "automatic signature help",
              get = function() return require("astrolsp").config.features.signature_help end,
              set = function() require("astrolsp.toggles").signature_help() end,
              notify = false,
            })
            :map("<Leader>u?", { buffer = bufnr })
        end
        if vim.lsp.inlay_hint and client:supports_method("textDocument/inlayHint") then
          toggle
            .new({
              name = "LSP inlay hints (buffer)",
              get = function()
                local filter = { bufnr = bufnr }
                return vim.lsp.inlay_hint.is_enabled(filter)
              end,
              set = function(should_enable)
                local filter = { bufnr = bufnr }
                if should_enable then
                  vim.lsp.inlay_hint.enable(true, filter)
                else
                  vim.lsp.inlay_hint.enable(false, filter)
                end
              end,
            })
            :map("<Leader>uh", { buffer = bufnr })
          toggle
            .new({
              name = "LSP inlay hints (global)",
              get = function() return vim.lsp.inlay_hint.is_enabled() end,
              set = function(should_enable)
                if should_enable then
                  vim.lsp.inlay_hint.enable(true)
                else
                  vim.lsp.inlay_hint.enable(false)
                end
              end,
            })
            :map("<Leader>uH", { buffer = bufnr })
        end
        if client:supports_method("textDocument/semanticTokens/full", bufnr) then
          toggle
            .new({
              name = "LSP semantic highlight (buffer)",
              get = function() return vim.b[bufnr].semantic_tokens end,
              set = function() require("astrolsp.toggles").buffer_semantic_tokens(bufnr) end,
              notify = false,
            })
            :map("<Leader>uY", { buffer = bufnr })
        end
        old_on_attach(client, bufnr)
      end
    end,
  },
}
