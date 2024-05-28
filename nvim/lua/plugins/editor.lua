return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {
			modes = {
				char = {
					enabled = false,
					jump_labels = false,
					keys = { ",", ";", "f", "F" },
				},
			},
		},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, false },
      { "S", mode = { "n", "x", "o" }, false },
      { ";", mode = {"n", "x", "o"}, false},
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "F", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, false},
      { "<c-f>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
	},
	-- Hihglight colors
	{
		"echasnovski/mini.hipatterns",
		event = "BufReadPre",
		opts = {},
	},
	{
		"telescope.nvim",
		priority = 1000,
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				",f",
				desc = "File Navigation",
			},

			{
				",fb",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
						cwd = vim.fn.expand("%:p:h"),
					})
				end,
				desc = "Lists files in the Current Buffer dir, respects .gitignore",
			},

			{
				",fr",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
						cwd = LazyVim.root(),
					})
				end,
				desc = "Lists files in your Root dir, respects .gitignore",
			},

			{
				",fc",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
						cwd = vim.fn.getcwd(),
					})
				end,
				desc = "Lists files in your CWD, respects .gitignore",
			},

			{
				",fp",
				function()
					local builtin = require("telescope.builtin")
					builtin.find_files({
						no_ignore = false,
						hidden = true,
						cwd = PineDir,
					})
				end,
				desc = "Lists files in Pined Directory, respects .gitignore",
			},

			{
				",n",
				desc = "String Finder",
			},

			{
				",nb",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep({
						cwd = vim.fn.expand("%:p:h"),
					})
				end,
				desc = "Search for a string in your current Buffer directory and get results live as you type, respects .gitignore",
			},

			{
				",nr",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep({
						cwd = LazyVim.root(),
					})
				end,
				desc = "Search for a string in your Root Dir and get results live as you type, respects .gitignore",
			},

			{
				",nc",
				function()
					local builtin = require("telescope.builtin")
					builtin.live_grep({
						cwd = vim.fn.getcwd(),
					})
				end,
				desc = "Search for a string in your CWD and get results live as you type, respects .gitignore",
			},

			{
				",\\",
				function()
					local builtin = require("telescope.builtin")
					builtin.buffers({
						mappings = {
							n = {
								["<c-d>"] = require("telescope.actions").delete_buffer,
							}, -- n
							i = {
								["<c-d>"] = require("telescope.actions").delete_buffer,
							},
						},
					})
				end,
				desc = "Lists open buffers",
			},
			{
				",,",
				function()
					local builtin = require("telescope.builtin")
					builtin.resume()
				end,
				desc = "Resume the previous telescope picker",
			},
			{
				",e",
				function()
					local builtin = require("telescope.builtin")
					builtin.diagnostics()
				end,
				desc = "Lists Diagnostics for all open buffers or a specific buffer",
			},
			{
				",s",
				function()
					local builtin = require("telescope.builtin")
					builtin.treesitter()
				end,
				desc = "Lists Function names, variables, from Treesitter",
			},
		},
		config = function(_, opts)
			local telescope = require("telescope")

			opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
				wrap_results = true,
				layout_strategy = "horizontal",
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
				winblend = 0,
				mappings = {
					n = {
						["<C-d>"] = require("telescope.actions").delete_buffer,
					}, -- n
					i = {
						["<C-d>"] = require("telescope.actions").delete_buffer,
					},
				},
			})
			opts.pickers = {
				diagnostics = {
					theme = "ivy",
					initial_mode = "normal",
					layout_config = {
						preview_cutoff = 9999,
					},
				},
			}
			telescope.setup(opts)
			require("telescope").load_extension("fzf")
		end,
	},
}
