local opts = { noremap = true, silent = true }


vim.keymap.set("n", "<leader>me", function ()
    local filename = vim.fn.expand('%')
    vim.system({ "typora", filename }, { detach = true })
end, opts)

vim.keymap.set("n", "<Leader>md", ":vertical botright terminal leaf -w %<CR>", opts)
