---@type LazySpec
return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    -- config variable is the default configuration table for the setup function call
    local nls = require("null-ls")
    local h = require("null-ls.helpers")
    local u = require("null-ls.utils")

    -- Check supported formatters and linters
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    opts.diagnostics_format = "#{m} [#{c}] "
    opts.sources = {
      -- nls.builtins.formatting.pyink.with {
      --   extra_args = {
      --     "--line-length=120",
      --   },
      -- },
      nls.builtins.diagnostics.mypy.with {
        extra_args = function()
          local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
          return { "--python-executable", (venv and venv .. "/bin/python3") or "python3" }
        end,
      },
      nls.builtins.formatting.stylua.with {
        args = function(params)
          local args = {
            "--stdin-filepath",
            "$FILENAME",
            "-",
          }
          if u.root_pattern(".stylua.toml")(params.root) then
            table.insert(args, 1, "--config-path")
            table.insert(args, 2, params.root .. "/.stylua.toml")
          else
            table.insert(args, 1, "--search-parent-directories")
          end
          return args
        end,
      },
    }
    if vim.fn.executable("kulala-fmt") == 1 then
      table.insert(
        opts.sources,
        h.make_builtin {
          name = "kulala-fmt",
          meta = {
            url = "https://github.com/mistweaverco/kulala-fmt",
            description = "An opinionated .http and .rest files linter and formatter",
          },
          method = nls.methods.FORMATTING,
          filetypes = { "http" },
          generator_opts = {
            command = "kulala-fmt",
            to_stdin = true,
            args = { "format", "--stdin" },
          },
          factory = h.formatter_factory,
        }
      )
    end
    return opts -- return final config table
  end,
  specs = {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>ln"] = { function() require("null-ls").toggle {} end, desc = "None-ls toggle" }
    end,
  },
}
