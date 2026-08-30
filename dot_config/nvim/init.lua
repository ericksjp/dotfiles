-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

require("utils.toggle_theme").setup({
    filepath = vim.fn.expand("$HOME/.local/share/nvim/bgfile"),
    light_theme = "jb",
    dark_theme = "vscode",
})
