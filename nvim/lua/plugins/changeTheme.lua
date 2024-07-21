return {
  "eriedaberrie/colorscheme-file.nvim",
  config = function()
    require("colorscheme-file").setup({
      path = vim.fn.stdpath("config") .. "/colorscheme-file.txt",
      fallback = "vscode",
      silent = true,
    })
  end,
}
