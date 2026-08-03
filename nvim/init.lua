-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("utils.toggle_theme").setup({
    filepath = vim.fn.expand("$HOME/.theme"),
    light_theme = "jb",
    dark_theme = "vscode",
})
