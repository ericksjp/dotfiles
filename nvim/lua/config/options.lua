vim.g.mapleader = " "

vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.laststatus = 0
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.inccommand = "split"
vim.opt.ignorecase = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "cursor"
vim.opt.mouse = ""
vim.opt.list = true
vim.opt.foldmethod = "manual"
vim.opt.formatoptions:append({ "r" })
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

local whiteOpts = {
	sections = {
		lualine_a = {
			{
				"mode",
				padding = { left = 1 },
				color = { fg = "#000000", bg = "none", gui = "bold" },
			},
		},
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = { { "progress", color = { fg = "#000000" } } },
		lualine_z = {
			{
				"location",
				color = { fg = "#000000", bg = "none", gui = "bold" },
			},
		},
	},
}

local blackOpts = {
	sections = {
		lualine_a = {
			{
				"mode",
				padding = { left = 1 },
				color = { fg = "#ffffff", bg = "none", gui = "bold" },
			},
		},
		lualine_b = { "branch" },
		lualine_c = { "filename" },
		lualine_x = {},
		lualine_y = { { "progress", color = { fg = "#ffffff" } } },
		lualine_z = {
			{
				"location",
				color = { fg = "#ffffff", bg = "none", gui = "bold" },
			},
		},
	},
}

function SET_COLORSCHEME()
	if vim.o.background == "dark" then
		vim.cmd("colorscheme mellifluous")
		require("lualine").setup(blackOpts)
	else
		vim.cmd("colorscheme onenord")
		require("lualine").setup(whiteOpts)
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		SET_COLORSCHEME()
		local arg = vim.fn.argv(0)
		if arg == "." then
			vim.defer_fn(function()
				require("oil").open(vim.fn.getcwd())
			end, 10)
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "oil://*",
	callback = function()
		os.execute("zoxide add " .. require("oil").get_current_dir())
	end,
})

vim.api.nvim_create_autocmd("DirChanged", {
	pattern = "*",
	callback = function()
		if ChangeWithCWD == true then
			local oilOpen = require("oil").get_current_dir()
			if oilOpen ~= nil and oilOpen ~= vim.fn.getcwd() then
				vim.defer_fn(function()
					require("oil.actions").open_cwd.callback()
				end, 10)
			end
		end
	end,
})

vim.api.nvim_create_autocmd("OptionSet", {
	pattern = "background",
	callback = SET_COLORSCHEME,
})
