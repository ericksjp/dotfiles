return {
  {
    "aktersnurra/no-clown-fiesta.nvim",
    config = function()
      require("no-clown-fiesta").setup({
        transparent = true, -- Enable this to disable the bg color
        styles = {
          -- You can set any of the style values specified for `:h nvim_set_hl`
          comments = {},
          functions = {},
          keywords = {},
          lsp = { underline = true },
          match_paren = {},
          type = { bold = true },
          variables = {},
        },
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    config = function()
      require("vscode").setup({
        -- style = "light",
        transparent = true,
        italic_comments = true,
        underline_links = true,
        disable_nvimtree_bg = false,
      })
    end,
  },
}
