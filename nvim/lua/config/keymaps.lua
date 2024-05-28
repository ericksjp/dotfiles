local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
keymap.set("n", "<Leader>h", '"_')
keymap.set("n", "yl", "0y$")
keymap.set("n", "dl", "0d$")
keymap.set("n", "cl", "0c$")

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

keymap.set("n", "\\", "/")

-- Select all

keymap.set("n", "<C-a>", "gg<S-v>G")

-- Save file and quit
keymap.set("n", "<Leader>wa", ":w<Return>", opts)
keymap.set("n", "<Leader>wA", ":wall<Return>", opts)
keymap.set("n", "<Leader>qw", ":sus<Return>", opts)
-- keymap.set("n", "<Leader>q", ":quit<Return>", opts)

-- Tabs
keymap.set("n", "<tab>", ":tabnext<Return>", opts)

-- Split window
keymap.set("n", "ss", ":split<Return>", opts)
keymap.set("n", "sv", ":vsplit<Return>", opts)

-- Resize window
keymap.set("n", "<C-S-h>", "<C-w><")
keymap.set("n", "<C-S-l>", "<C-w>>")
keymap.set("n", "<C-S-k>", "<C-w>+")
keymap.set("n", "<C-S-j>", "<C-w>-")

keymap.set("n", "L", ":bnext<CR>", opts)
keymap.set("n", "H", ":bprev<CR>", opts)

-- -- Diagnostics
keymap.set("n", "<C-j>", function()
	vim.diagnostic.goto_next()
end, opts)

-- Navigate vim panes better
keymap.set("n", "<C-l>", function()
	require("tmux").move_left()
end, opts)
keymap.set("n", "<C-h>", function()
	require("tmux").move_right()
end, opts)
keymap.set("n", "<C-j>", function()
	require("tmux").move_bottom()
end, opts)
keymap.set("n", "<C-k>", function()
	require("tmux").move_top()
end, opts)

-- enter the cmd
keymap.set("n", "ç", ": <backspace>")

-- delete all buffers
keymap.set("n", "<Leader>ba", function()
	vim.cmd("%bd")
end, opts)

-- some of my
ChangeWithCWD = true
PineDir = "/home/erick/"

function SetPineDir()
	if require("oil").get_current_dir() then
		PineDir = require("oil").get_current_dir()
	else
		PineDir = vim.fn.expand("%:p:h")
	end

	print("PineDirectory =", PineDir)
end

keymap.set("n", "nc", ":cd ")
keymap.set("n", "nz", ":Z ")

keymap.set("n", "<Leader>cw", function()
	ChangeWithCWD = not ChangeWithCWD
	print("ChangeWithCWD =", ChangeWithCWD)
end, opts)
keymap.set("n", "<Leader>pd", ":lua SetPineDir()<CR>", opts)

local function spectreOpen(dir)
	require("spectre").open({
		is_insert_mode = true,
		cwr = dir,
		search_text = vim.fn.expand("<cword>"),
	})
	vim.defer_fn(function()
		vim.cmd("5")
	end, 100)
end

vim.keymap.set("n", "<leader>rc", function()
	spectreOpen(vim.fn.getcwd())
end)

vim.keymap.set("n", "<leader>rr", function()
	spectreOpen(LazyVim.root)
end)

vim.keymap.set("n", "<leader>rb", function()
	spectreOpen(vim.fn.expand("%:p:h"))
end)

vim.keymap.set("n", "<leader>rp", function()
	spectreOpen(PineDir)
end)
