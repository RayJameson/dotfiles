local extend_tbl = require("astrocore").extend_tbl
local prefix = "<Leader>f"

---@type LazySpec
return {
  "nvim-telescope/telescope.nvim",
  -- the first parameter is the plugin specification
  -- the second is the table of options as set up in Lazy with the `opts` key
  dependencies = { "debugloop/telescope-undo.nvim" },
  opts = function(_, opts)
    opts.extensions = {
      zoxide = {
        mappings = {
          ["<CR>"] = {
            action = function(selection)
              vim.cmd.edit(selection.path)
              vim.cmd.lcd(selection.path)
            end,
          },
          ["<C-t>"] = {
            action = function(selection)
              vim.cmd.tabedit(selection.path)
              vim.cmd.tcd(selection.path)
            end,
          },
          ["<C-x>"] = {
            action = function(selection)
              vim.cmd.split(selection.path)
              vim.cmd.lcd(selection.path)
            end,
          },
          ["<C-v>"] = {
            action = function(selection)
              vim.cmd.vsplit(selection.path)
              vim.cmd.lcd(selection.path)
            end,
          },
        },
      },
      undo = {
        use_delta = false,
        use_custom_command = (
          vim.fn.executable("diff-so-fancy") == 1 and { "bash", "-c", "echo '$DIFF' | diff-so-fancy | tail -n +6 " }
        ) or nil,
        layout_strategy = "vertical",
        layout_config = {
          preview_height = 0.5,
          preview_cutoff = 0.3,
        },
        mappings = {
          i = {
            ["<cr>"] = function() require("telescope-undo.actions").restore() end,
            ["<S-cr>"] = function() require("telescope-undo.actions").yank_additions() end,
            ["<C-cr>"] = function() require("telescope-undo.actions").yank_deletions() end,
          },
          n = {
            ["y"] = function() require("telescope-undo.actions").yank_additions() end,
            ["Y"] = function() require("telescope-undo.actions").yank_deletions() end,
            ["u"] = function() require("telescope-undo.actions").restore() end,
          },
        },
      },
    }
  end,
  config = function(plugin, opts)
    -- require telescope and load extensions as necessary
    require("astronvim.plugins.configs.telescope")(plugin, opts)
    local telescope = require("telescope")
    local conditional_func = require("astrocore").conditional_func
    conditional_func(telescope.load_extension, pcall(require, "telescope-undo"), "undo")
    conditional_func(telescope.load_extension, pcall(require, "telescope._extensions.zoxide"), "zoxide")

    local actions = require("telescope.actions")
    local from_entry = require("telescope.from_entry")

    local yank_path_or_content = function(modifier)
      return function(prompt_bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        local filename_or_content = from_entry.path(entry, false, false)
        local name = (
          type(filename_or_content) == "string" and vim.fn.fnamemodify(filename_or_content, modifier)
          or filename_or_content.regcontents
        ) or ""
        vim.fn.setreg('"', name)
        actions.close(prompt_bufnr)
      end
    end
    local select_one_or_multi = function(prompt_bufnr)
      local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require("telescope.actions").close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then vim.cmd(string.format("%s %s", "edit", j.path)) end
        end
      else
        require("telescope.actions").select_default(prompt_bufnr)
      end
    end

    for _, mode in ipairs { "i", "n" } do
      opts.defaults.mappings[mode] = extend_tbl(opts.defaults.mappings[mode], {
        ["<C-q>"] = actions.smart_add_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-l>"] = actions.smart_add_to_loclist + actions.open_loclist,
        ["<M-l>"] = actions.smart_send_to_loclist + actions.open_loclist,
        ["<CR>"] = select_one_or_multi,
        ["<C-y>"] = yank_path_or_content(":."),
        ["<C-Y>"] = yank_path_or_content(),
        ["<C-g>"] = actions.delete_buffer,
      })
    end
  end,
  keys = {
    { prefix .. "u", function() require("telescope").extensions.undo.undo() end, desc = "Undo history" },
    { prefix .. "s", function() require("telescope.builtin").spell_suggest() end, desc = "Spell suggestions" },
    { prefix .. "g", function() require("telescope.builtin").git_files() end, desc = "Git files" },
  },
  ---@type LazySpec
  specs = {
    "AstroNvim/astrocore",
    opts = function(_, opts)
      local maps = opts.mappings
      maps.n["<Leader>ls"] = {
        desc = "Find symbols",
      }
      maps.n["<Leader>lsa"] = {
        function() require("telescope.builtin").lsp_document_symbols() end,
        desc = "Find all symbols",
      }
      maps.n["<Leader>lsf"] = {
        function() require("telescope.builtin").lsp_document_symbols { symbols = { "function" } } end,
        desc = "Find functions symbols",
      }
      maps.n["<Leader>lsm"] = {
        function() require("telescope.builtin").lsp_document_symbols { symbols = { "method" } } end,
        desc = "Find method symbols",
      }
      maps.n["<Leader>lsv"] = {
        function() require("telescope.builtin").lsp_document_symbols { symbols = { "variable" } } end,
        desc = "Find variable symbols",
      }
      maps.n["<Leader>lsc"] = {
        function() require("telescope.builtin").lsp_document_symbols { symbols = { "class" } } end,
        desc = "Find class symbols",
      }
      maps.x["<Leader>fc"] =
        { function() require("telescope.builtin").grep_string() end, desc = "Visually selected text" }
      maps.n["<Leader>fp"] = {
        function()
          require("telescope.builtin").find_files {
            ---@diagnostic disable-next-line: param-type-mismatch
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
          }
        end,
        desc = "Plugins files",
      }
      maps.n["<Leader>fw"] = { function() require("telescope-multigrep").search() end, desc = "Words" }
      maps.n["<Leader>fW"] = {
        function()
          require("telescope-multigrep").search {
            all_files = true,
            prompt_title = "Live Grep (with shortcuts) in all files",
          }
        end,
        desc = "Words in all files",
      }
      maps.n["<Leader>fP"] = {
        function()
          require("telescope-multigrep").search {
            ---@diagnostic disable-next-line: param-type-mismatch
            cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
            prompt_title = "Live Grep (with shortcuts) in plugins files",
          }
        end,
        desc = "Words in plugins files",
      }
    end,
  },
}
