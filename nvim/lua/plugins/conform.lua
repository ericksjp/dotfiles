return {
    "stevearc/conform.nvim",
    opts = function(_, opts)
        opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft, {
            javascript = { "prettier" },
        })

        opts.formatters = vim.tbl_extend("force", opts.formatters, {
            prettier = {
                prepend_args = { "--tab-width", "4", "--print-width", "120" },
            },
        })

        return opts
    end,
}
