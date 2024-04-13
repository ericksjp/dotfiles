return {
	"stevearc/conform.nvim",
	opts = {
		-- LazyVim will use these options when formatting with the conform.nvim formatter
		formatters_by_ft = {
			["javascript"] = { "prettier" },
			["javascriptreact"] = { "prettier" },
			["typescript"] = { "prettier" },
			["typescriptreact"] = { "prettier" },
			["vue"] = { "prettier" },
			["css"] = { "prettier" },
			["scss"] = { "prettier" },
			["less"] = { "prettier" },
			["html"] = { "prettier" },
			["json"] = { "prettier" },
			["jsonc"] = { "prettier" },
			["yaml"] = { "prettier" },
			["markdown"] = { "prettier" },
			["markdown.mdx"] = { "prettier" },
			["graphql"] = { "prettier" },
			["handlebars"] = { "prettier" },
			["java"] = { "java-lang-format" },
			["c"] = { "clang-format" },
			["c#"] = { "clang-format" },
			["c++"] = { "clang-format" },
		},
	},
}
