return {
  "eriedaberrie/colorscheme-file.nvim",
  config = function()
    require("colorscheme-file").setup({
      path = vim.fn.stdpath("config") .. "/colorscheme-file.txt",
      fallback = "dark",
      silent = true,
    })
  end,
}
