return {
  {
    "gmr458/cold.nvim",
    lazy = false,
  },
  {
    "sainnhe/sonokai",
    lazy = false,
    config = function()
      -- vim.g.sonokai_style = "shusia"
      -- vim.g.edge_enable_italic = 1
      -- vim.g.sonokai_enable_italic = true
      vim.g.sonokai_better_performance = true
    end,
  },
  {
    "sainnhe/edge",
    lazy = false,
    config = function()
      vim.g.edge_style = "neon"
      vim.g.edge_enable_italic = 1
      vim.g.edge_disable_italic_comment = 1
      vim.g.edge_better_performance = 1
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    config = function()
      require("vscode").setup({
        style = "dark",
        transparent = true,
        italic_comments = true,
        underline_links = false,
        disable_nvimtree_bg = true,
      })
    end,
  },
}
