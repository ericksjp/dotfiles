local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- delete without copy
keymap.set("n", "x", '"_x')
keymap.set("n", ",", '"_')

-- line motions
keymap.set("n", "yl", "0y$")
keymap.set("n", "dl", "0d$")
keymap.set("n", "cl", "0c$")

-- Increment/decrement
keymap.set("n", "+", "<C-a>")
keymap.set("n", "-", "<C-x>")

-- easier search
keymap.set("n", "\\", "/")

-- easier actions
keymap.set("n", "t", "@")

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G")

-- easy quotes
keymap.set("i", "<C-q>", "'", opts)
keymap.set("i", "<C-e>", '"', opts)

-- Save file and quit
keymap.set("n", "<Leader>wa", ":w<CR>")
keymap.set("n", "<Leader>wA", ":wall<CR>")
keymap.set("n", "<Leader>qw", ":sus<CR>", opts)

-- Tabs
keymap.set("n", "<tab>", ":tabnext<Return>", opts)

-- Split window
keymap.set("n", "<leader>wh", ":split<Return>", opts)
keymap.set("n", "<leader>wv", ":vsplit<Return>", opts)

-- navigate through buffers
keymap.set("n", "L", ":bnext<CR>", opts)
keymap.set("n", "H", ":bprev<CR>", opts)

-- Navigate vim panes better
keymap.set("n", "<C-l>", function()
  require("tmux").move_left()
end, opts)
keymap.set("n", "<C-h>", function()
  require("tmux").move_right()
end, opts)
keymap.set("n", "<C-j>", function()
  require("tmux").move_bottom()
end, opts)
keymap.set("n", "<C-k>", function()
  require("tmux").move_top()
end, opts)

-- enter the cmd easier
keymap.set("n", "ç", ": <backspace>")

-- move with through directories easier
keymap.set("n", "nc", ":cd ")
keymap.set("n", "nz", ":Z ")

-- delete all buffers
keymap.set("n", "<Leader>ba", function()
  vim.cmd("%bd")
end, opts)

-- set the pine directory
PineDir = "/home/erick/"
local function SetPineDir()
  if require("oil").get_current_dir() then
    PineDir = require("oil").get_current_dir()
  else
    PineDir = vim.fn.expand("%:p:h")
  end

  print("PineDirectory =", PineDir)
end
keymap.set("n", "<Leader>pd", SetPineDir, opts)

-- change cwd with oil
ChangeWithCWD = true
keymap.set("n", "<Leader>cw", function()
  ChangeWithCWD = not ChangeWithCWD
  print("ChangeWithCWD =", ChangeWithCWD)
end, opts)

-- easier spectre
local function spectreOpen(dir)
  require("spectre").open({
    is_insert_mode = true,
    cwr = dir,
    search_text = vim.fn.expand("<cword>"),
  })
  vim.defer_fn(function()
    vim.cmd("5")
  end, 100)
end

vim.keymap.set("n", "<leader>rc", function()
  spectreOpen(vim.fn.getcwd())
end)

vim.keymap.set("n", "<leader>rr", function()
  spectreOpen(LazyVim.root)
end)

vim.keymap.set("n", "<leader>rb", function()
  spectreOpen(vim.fn.expand("%:p:h"))
end)

vim.keymap.set("n", "<leader>rp", function()
  spectreOpen(PineDir)
end)

-- git helpers
vim.keymap.set("n", "<Leader>jn", ":Neogit<CR>", { silent = true, noremap = true, desc = "Open Neogit" })
vim.keymap.set("n", "<Leader>jc", ":Neogit commit<CR>", { silent = true, noremap = true, desc = "Commit changes" })
vim.keymap.set("n", "<Leader>jp", ":Neogit pull<CR>", { silent = true, noremap = true, desc = "Pull changes" })
vim.keymap.set("n", "<Leader>je", ":Neogit push<CR>", { silent = true, noremap = true, desc = "Push changes" })

vim.keymap.set("n", "<Leader>kc", function()
  require("telescope.builtin").git_commits({
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.99,
      preview_width = 0.6,
    },
  })
end, { silent = true, noremap = true, desc = "List commits" })

vim.keymap.set("n", "<Leader>kb", function()
  require("telescope.builtin").git_branches({
    layout_strategy = "horizontal",
    layout_config = {
      width = 0.99,
      preview_width = 0.6,
    },
  })
end, { silent = true, noremap = true, desc = "List branches" })
