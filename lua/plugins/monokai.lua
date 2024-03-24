return {
	"polirritmico/monokai-nightasty.nvim",
	lazy = false,
	priority = 1000,
	keys = {
		{ "<leader>tt", "<cmd>MonokaiToggleLight<cr>", desc = "Monokai-Nightasty: Toggle dark/light theme." },
	},
	opts = {
		dark_style_background = "transparent", -- default, dark, transparent, #color
		light_style_background = "default", -- default, dark, transparent, #color
		color_headers = false, -- Enable header colors for each header level (h1, h2, etc.)
		lualine_bold = true, -- Lualine a and z sections font width
		lualine_style = "default", -- "dark", "light" or "default" (Follows dark/light style)
		-- Style to be applied to different syntax groups. See `:help nvim_set_hl`
		hl_styles = {
			keywords = { italic = true },
			comments = { italic = true },
		},

		--- You can override specific color/highlights. Theme color values
		--- in `extras/palettes`. Also could be any hex RGB color you like.
		on_colors = function(colors)
			-- Custom color only for light theme
			local current_is_light = vim.o.background == "light"
			colors.comment = current_is_light and "#2d7e79" or colors.grey
			-- Custom color only for dark theme
			colors.border = not current_is_light and colors.magenta or colors.border
		end,
		on_highlights = function(highlights, colors)
			-- You could add styles like bold, underline, italic
			highlights.TelescopeSelection = { bold = true }
			highlights.TelescopeBorder = { fg = colors.grey }
			highlights["@lsp.type.property.lua"] = { fg = colors.fg }
		end,
	},
	config = function(_, opts)
		-- Highlight line at the cursor position
		vim.opt.cursorline = true

		-- Default to dark theme
		vim.o.background = "dark" -- dark | light

		require("monokai-nightasty").load(opts)
	end,
}
