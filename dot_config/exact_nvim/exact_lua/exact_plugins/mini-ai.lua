---@type LazySpec
return {
  "echasnovski/mini.ai",
  event = { "User AstroFile", "InsertEnter" },
  opts = {
    silent = true,
    search_method = "cover_or_nearest",
    mappings = { around_last = "", inside_last = "" }, -- keep Neovim 0.13 built-in `al`/`il`
    custom_textobjects = {
      b = { { "%b()", "%b[]", "%b{}", "%b<>" }, "^.().*().$" },
    },
  },
}
