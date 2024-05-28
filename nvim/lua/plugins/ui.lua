return {
	{
		"lukas-reineke/indent-blankline.nvim",
		enabled = false,
	},
	{
		"echasnovski/mini.indentscope",
		enabled = false,
	},
	{
		"nvimdev/dashboard-nvim",
		enabled = false,
	},
	{
		"nvim-lualine/lualine.nvim",
		enabled = true,
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = "vscode",
					component_separators = { left = "-", right = "-" },
					section_separators = { left = "", right = "" },
				},
			})
		end,
	},

	-- messages, cmdline and the popupmenu
	{
		"folke/noice.nvim",
		-- config = function()
		-- 	require("noice").setup({
		-- 		cmdline = {
		-- 			view = "cmdline",
		-- 		},
		-- 	})
		-- end,
		opts = function(_, opts)
			table.insert(opts.routes, {
				filter = {
					event = "notify",
					find = "No information available",
				},
				opts = { skip = true },
			})
			local focused = true
			vim.api.nvim_create_autocmd("FocusGained", {
				callback = function()
					focused = true
				end,
			})
			vim.api.nvim_create_autocmd("FocusLost", {
				callback = function()
					focused = false
				end,
			})
			table.insert(opts.routes, 1, {
				filter = {
					cond = function()
						return not focused
					end,
				},
				view = "notify_send",
				opts = { stop = false },
			})

			opts.cmdline = {
				view = "cmdline", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
				format = {
					cmdline = {
						icon = " :",
					},
					lua = {
						icon = " :𝗟",
					},
					filter = {
						icon = " :$",
					},
					help = {
						icon = " :",
					},
					search_down = {
						icon = "  ",
					},
					search_up = {
						icon = "  ",
					},
				},
			}

			opts.popupmenu = {
				backend = "cmp",
			}

			opts.commands = {
				all = {
					-- options for the message history that you get with `:Noice`
					view = "split",
					opts = { enter = true, format = "details" },
					filter = {},
				},
			}

			opts.presets.lsp_doc_border = true
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			timeout = 5000,
			background_colour = "#000000",
			render = "wrapped-compact",
		},
	},
	-- buffer line
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		keys = {
			{ "<Tab>", "<Cmd>BufferLineCycleNext<CR>", desc = "Next tab" },
			{ "<S-Tab>", "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev tab" },
		},
		opts = {
			options = {
				mode = "tabs",
				show_buffer_close_icons = false,
				show_close_icon = false,
			},
		},
	},
}
