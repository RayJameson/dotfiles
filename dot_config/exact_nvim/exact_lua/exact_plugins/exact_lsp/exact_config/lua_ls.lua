-- lua_ls puts a reference lens on every function that is assigned or returned;
-- drop the ones on table fields (`opts = function`) and `return function`
local function is_noisy_lens(bufnr, lens)
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "lua")
  if not ok or not parser then return false end
  parser:parse()
  local start = lens.range.start
  local node = vim.treesitter.get_node { bufnr = bufnr, pos = { start.line, start.character }, ignore_injections = true }
  while node do
    local type = node:type()
    if type == "field" or type == "return_statement" then return true end
    if type == "assignment_statement" or type == "variable_declaration" or type == "function_declaration" then
      return false
    end
    node = node:parent()
  end
  return false
end

---@type LazySpec
return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    ---@diagnostic disable: missing-fields
    config = {
      lua_ls = {
        -- nvim's codelens passes its own callback to client:request, so filter there instead of in `handlers`
        on_init = function(client)
          local request = client.request
          client.request = function(self, method, params, handler, bufnr)
            if method == "textDocument/codeLens" and handler then
              local orig_handler = handler
              handler = function(err, result, ctx)
                if result and ctx.bufnr and vim.api.nvim_buf_is_valid(ctx.bufnr) then
                  result = vim.tbl_filter(function(lens) return not is_noisy_lens(ctx.bufnr, lens) end, result)
                end
                return orig_handler(err, result, ctx)
              end
            end
            return request(self, method, params, handler, bufnr)
          end
        end,
        settings = {
          Lua = {
            format = {
              enable = false,
            },
            hover = {
              expandAlias = false,
              previewFields = 100,
              enumsLimit = 100,
            },
            hint = {
              enable = true,
              arrayIndex = "Disable",
            },
            workspace = {
              checkThirdParty = false,
            },
            diagnostics = {
              disable = { "lowercase-global" },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
    },
  },
}
