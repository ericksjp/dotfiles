return {
  {
    "sainnhe/sonokai",
    lazy = true,
    config = function()
      vim.cmd([[
                let g:sonokai_style = 'default'
                let g:sonokai_background = 'soft'
                " For better performance
                let g:sonokai_better_performance = 1
                let g:sonokai_transparent_background = 0
                let g:sonokai_float_style = 'dim'
                " let g:sonokai_colors_override = {'bg1': ['#171717', '100']}
            ]])
    end,
  },
  {
    "nickkadutskyi/jb.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- set this in init.lua
      -- vim.api.nvim_set_hl(0, "javaExceptions", { link = "Keyword", underline = false })

      require("jb").setup({
        transparent = false,
        snacks = {
          explorer = {
            enabled = true,
          },
        },
      })
      -- vim.cmd("colorscheme jb")
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup({
        style = "dark",
        transparent = false,
        italic_comments = true,
        underline_links = true,
        -- disable_nvimtree_bg = false,
      })
    end,
  },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({})
    end,
  },
  {
    "HoNamDuong/hybrid.nvim",
    lazy = true,
    priority = 1000,
    config = function()
      require("hybrid").setup({
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
          strings = false,
          emphasis = true,
          comments = true,
          folds = true,
        },
        strikethrough = true,
        inverse = true,
        transparent = false,
      })
    end,
  },
  {
    "aktersnurra/no-clown-fiesta.nvim",
    config = function()
      require("no-clown-fiesta").setup({
        transparent = true,
      })
    end,
  },
}
