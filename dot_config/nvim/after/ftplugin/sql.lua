local opts = { buffer = true, noremap = true, silent = true }
vim.keymap.set({"n", "v"}, "<localleader><localleader>", "<Plug>(DBUI_ExecuteQuery)", opts)
vim.keymap.set("n", "<localleader> ", "<Plug>(DBUI_SaveQuery)", opts)
vim.keymap.set("n", "<localleader>e", "<Plug>(DBUI_EditBindParameters)", opts)
