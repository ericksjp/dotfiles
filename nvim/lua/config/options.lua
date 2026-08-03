vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.showbreak = "↪ "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.clipboard = "unnamedplus"
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = false
vim.opt.cmdheight = 0
vim.g.lazyvim_picker = "telescope"
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.scrolloff = 20
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.modifiable = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
-- vim.opt.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = "a"
vim.opt.list = false
vim.opt.foldmethod = "manual"
vim.opt.formatoptions:append({ "r" })
vim.opt.termguicolors = true
-- vim.g.oil_default_explorer = 1
vim.g.autoformat = false -- globally
vim.opt.guicursor = {
    "n:block", -- Block cursor in normal mode
    "i:ver25", -- Vertical bar cursor in insert mode
    "v:hor20", -- Underscore cursor in visual mode
}

vim.o.showtabline = 1
vim.g.lazyvim_cmp = "nvim-cmp"
vim.g.autoformat = false
vim.opt.colorcolumn = "80"
vim.opt.textwidth = 80
vim.opt.showbreak = ""

vim.g.lazyvim_picker = "fzf"

-- vim.opt.wrap = false
-- vim.opt_local.wrap = false
-- vim.opt_local.linebreak = false
-- vim.opt_local.breakindent = false
-- vim.opt_local.showbreak = "↪"
-- vim.opt_local.conceallevel = 2
-- vim.opt_local.spell = false
-- vim.opt_local.list = false
