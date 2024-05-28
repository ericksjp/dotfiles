return {
	"eriedaberrie/colorscheme-file.nvim",
	config = function()
		require("colorscheme-file").setup({
			fallback = "dark",
			silent = false,
		})
	end,
}
