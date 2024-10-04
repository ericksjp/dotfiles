local detail = false

return {
  "stevearc/oil.nvim",
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        -- ["wv"] = "actions.select_vsplit",
        -- ["wj"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-ç>"] = "actions.preview",
        ["q"] = "actions.close",
        ["<C-y>"] = "actions.refresh",
        ["e"] = "actions.parent",
        ["´"] = "actions.open_cwd",
        -- ["<C-n>"] = "actions.cd",
        ["<C-b>"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["H"] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["K"] = {
          desc = "Toggle file and details",
          callback = function()
            detail = not detail
            if detail then
              require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
            else
              require("oil").set_columns({ "icon" })
            end
          end,
        },
      },
      use_default_keymaps = false,
    })
  end,

  keys = {
    {
      "<leader><leader>",
      function()
        require("oil").open(LazyVim.root())
      end,
      silent = true,
      desc = "Open Oil (Root dir)",
    },
    {
      "<leader>e",
      function()
        require("oil").open(vim.fn.getcwd())
      end,
      silent = true,
      desc = "Open Oil (cwd)",
    },
    {
      "<leader>o",
      function()
        require("oil").open(vim.fn.expand("%:p:h"))
      end,
      silent = true,
      desc = "Open Oil (Current Buffer dir)",
    },
    {
      "<leader>fe",
      function()
        require("oil").open(require("utils.pineDir").getPineDir())
      end,
      silent = true,
      desc = "Open Oil (PineDir)",
    },
    {
      "<leader>fn",
      function()
        require("oil").open("~/notes")
      end,
      silent = true,
      desc = "Open notes",
    },
  },
}
