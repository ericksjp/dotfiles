return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("oil").setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        -- ["vv"] = "actions.select_vsplit",
        -- ["ss"] = "actions.select_split",
        ["<C-t>"] = "actions.select_tab",
        ["<C-i>"] = "actions.preview",
        ["q"] = "actions.close",
        ["<C-y>"] = "actions.refresh",
        ["e"] = "actions.parent",
        ["´"] = "actions.open_cwd",
        ["<C-n>"] = "actions.cd",
        ["<C-b>"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["H"] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
      },
      use_default_keymaps = false,
      float = {
        padding = 0,
        max_width = 70,
        max_height = 40,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        override = function(conf)
          return conf
        end,
      },
    })
  end,

  keys = {
    {
      "sb",
      function()
        require("oil").open()
      end,
      silent = true,
      desc = "Open Oil (Current Buffer dir)",
    },
    {
      "sr",
      function()
        require("oil").open(LazyVim.root())
      end,
      silent = true,
      desc = "Open Oil (Root dir)",
    },
    {
      "sc",
      function()
        require("oil").open(vim.fn.getcwd())
      end,
      silent = true,
      desc = "Open Oil (cwd)",
    },
    {
      "sp",
      function()
        require("oil").open(PineDir)
      end,
      silent = true,
      desc = "Open Oil (PineDir)",
    },
    -- {
    --   "ssb",
    --   function()
    --     require("oil").open_float()
    --   end,
    --   silent = true,
    --   desc = "Open Float Oil (Current Buffer dir)",
    -- },
    -- {
    --   "ssr",
    --   function()
    --     require("oil").open_float(LazyVim.root())
    --   end,
    --   silent = true,
    --   desc = "Open Float Oil (Root dir)",
    -- },
    -- {
    --   "ssc",
    --   function()
    --     require("oil").open_float(vim.fn.getcwd())
    --   end,
    --   silent = true,
    --   desc = "Open Float Oil (cwd)",
    -- },
    -- {
    --   "ssp",
    --   function()
    --     require("oil").open_float(PineDir)
    --   end,
    --   silent = true,
    --   desc = "Open Float Oil (PineDir)",
    -- },
  },
}
