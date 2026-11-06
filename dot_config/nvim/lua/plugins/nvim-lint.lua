-- append the code to messages, like none-ls `diagnostics_format = "#{m} [#{c}]"`
-- returns nil for custom or function-style linters: astrocommunity would replace those wholesale with our table
local function with_code(name)
  local ok, base = pcall(require, "lint.linters." .. name)
  if not ok or type(base) ~= "table" or type(base.parser) ~= "function" then return end
  local parser = base.parser
  return function(...)
    local diagnostics = parser(...)
    for _, d in ipairs(diagnostics) do
      local code = d.code and tostring(d.code)
      if code and not (d.message:find("[" .. code .. "]", 1, true) or vim.startswith(d.message, code)) then
        d.message = ("%s [%s]"):format(vim.trim(d.message), code)
      end
    end
    return diagnostics
  end
end

---@type LazySpec
return {
  "mfussenegger/nvim-lint",
  optional = true,
  opts = function(_, opts)
    local list_insert_unique = require("astrocore").list_insert_unique
    opts.linters_by_ft = opts.linters_by_ft or {}
    opts.linters_by_ft.lua = list_insert_unique(opts.linters_by_ft.lua, { "luacheck" })
    opts.linters_by_ft.python = list_insert_unique(opts.linters_by_ft.python, { "mypy" })
    opts.linters = opts.linters or {}
    for _, names in pairs(opts.linters_by_ft) do
      for _, name in ipairs(names) do
        local parser = with_code(name)
        if parser then opts.linters[name] = vim.tbl_extend("force", opts.linters[name] or {}, { parser = parser }) end
      end
    end
    -- pass the real file name so per-file settings in .luacheckrc apply (inserted before the trailing stdin "-")
    local luacheck_args = vim.deepcopy(require("lint.linters.luacheck").args)
    table.insert(luacheck_args, #luacheck_args, "--filename")
    table.insert(luacheck_args, #luacheck_args, function() return vim.api.nvim_buf_get_name(0) end)
    opts.linters.luacheck = vim.tbl_extend("force", opts.linters.luacheck or {}, { args = luacheck_args })
    -- shortcut: mypy is taken from PATH (activate a venv with :VenvSelect to use its mypy), not `.venv/bin` like
    -- none-ls `prefer_local`; a function `cmd` would break astrocommunity's executable check.
    local mypy_args = vim.list_extend(vim.deepcopy(require("lint.linters.mypy").args), {
      "--python-executable",
      function()
        local venv = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
        return (venv and venv .. "/bin/python3") or "python3"
      end,
    })
    opts.linters.mypy = vim.tbl_extend("force", opts.linters.mypy or {}, { args = mypy_args })
  end,
  specs = {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      opts.mappings.n["<Leader>ln"] = {
        function()
          local lint = require("lint")
          vim.g.lint_enabled = not vim.F.if_nil(vim.g.lint_enabled, true)
          for _, names in pairs(lint.linters_by_ft) do
            for _, name in ipairs(names) do
              vim.diagnostic.enable(vim.g.lint_enabled, { ns_id = lint.get_namespace(name) })
            end
          end
          require("astrocore").notify(("Linting %s"):format(vim.g.lint_enabled and "on" or "off"))
        end,
        desc = "Toggle linting",
      }
    end,
  },
}
