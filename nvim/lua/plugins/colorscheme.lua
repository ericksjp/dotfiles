return {
	{
		"catppuccin/nvim",
		enabled = false,
	},
	{
		"folke/tokyonight.nvim",
		enabled = false,
	},
	{
		"ramojus/mellifluous.nvim",
		-- version = "v0.*", -- uncomment for stable config (some features might be missed if/when v1 comes out)
		config = function()
			require("mellifluous").setup({
				mellifluous = {
					color_overrides = {
						dark = {
							main_keywords = "#AF5F6C",
							other_keywords = "#AF875F",
							types = "#616b8a",
							operators = "#919191",
							strings = "#7f9164",
							functions = "#919191",
							constants = "#ADD6A6",
							comments = "#4D4C48",
						},
					},
				},
				transparent_background = {
					enabled = true,
					floating_windows = true,
					telescope = true,
					file_tree = true,
					cursor_line = false,
					status_line = true,
				},
			}) -- optional, see configuration section.
		end,
	},
	{
		"rmehri01/onenord.nvim",
		config = function()
			require("onenord").setup({
				theme = "light",
				disable = {
					background = false,
					float_background = true, -- Disable setting the background color for floating windows
				},
			})
		end,
	},
	{
		"Mofiqul/vscode.nvim",
		config = function()
			require("vscode").setup({
				-- Alternatively set style in setup
				style = "dark",

				-- Enable transparent background
				transparent = true,

				-- Enable italic comment
				italic_comments = true,

				-- Underline `@markup.link.*` variants
				underline_links = true,

				-- Disable nvim-tree background color
				disable_nvimtree_bg = false,

				-- Override colors (see ./lua/vscode/colors.lua)
				-- color_overrides = {
				-- 	vscLineNumber = "#FFFFFF",
				-- },

				-- Override highlight groups (see ./lua/vscode/theme.lua)
				group_overrides = {
					-- this supports the same val table as vim.api.nvim_set_hl
					-- use colors from this colorscheme by requiring vscode.colors!
					-- Constanst = {}
					-- Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
					-- bg = { bg = "#1e1e1e" },
				},
			})
		end,
	},
}
