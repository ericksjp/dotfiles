local map = vim.keymap.set
map("n", "<localleader>r", ":Rest run<cr>", { silent = true, desc = "Send request", buffer = true })
map("n", "<localleader>l", ":Rest last req<cr>", { silent = true, desc = "Send the last request again", buffer = true })
map("n", "<localleader>e", ":Rest env select<cr>", { silent = true, desc = "Select environment variable", buffer = true })
