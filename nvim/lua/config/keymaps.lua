local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local marks = require("utils.marks")
-- require("utils.discipline"):cowboy()

-- delete without copy
map("n", "x", '"_x')
map("n", ",", '"_')
map("n", "<esc>", "<esc>:noh<cr>", opts)

map("n", "n", "nzz", opts)

-- super super s
map("n", "s", function()
  require("which-key").show("s")
end)

-- marks
map("n", "<leader>m", function()
  marks.listMarks()
end, { desc = "List Marks" })
map("n", "m", function()
  marks.goToMark()
end, { desc = "Go to Mark" })
map("n", "dm", function()
  marks.deleteMark()
end, { desc = "Delete Mark" })
map("n", "dM", ":delmarks a-z<CR>", { desc = "Delete All Marks" })
map("n", "M", function()
  marks.putMark()
end, { desc = "Put Mark" })

local function openTer(path)
  require("lazy.util").float_term(nil, {
    backdrop = nil,
    cwd = path,
    border = "single",
    style = "minimal",
    size = {
      width = 0.5,
      height = 0.5,
    },
  })
end

map("n", "<c-\\>", function()
  openTer(LazyVim.root())
end, { desc = "Terminal (Root Dir)" })

map("n", "<c-q>", function()
  local path = require("oil").get_current_dir() or vim.fn.expand("%:p:h")
  openTer(path)
end, { desc = "Terminal (Buffer Dir)" })

map("t", "<c-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

-- line motions
map("n", "yl", "0y$")
map("n", "dl", "0d$")
map("n", "cl", "0c$")

-- Increment/decrement
map({ "n", "v" }, "+", "<C-a>")
map({ "n", "v" }, "-", "<C-x>")

map("v", "<C-a>", "")
map("v", "<C-b>", "")

-- easier search
map("n", "\\", "/")

-- easier actions
map("n", "t", "@")

-- Select all
map("n", "<C-a>", "gg<S-v>G")

map("i", "<C-f>", "<Right>", opts)
map("i", "<C-b>", "<left>", opts)

-- easier escape
map("n", "<C-c>", ":qa<CR>", opts)

-- Tabs
map("n", "<leader><tab><tab>", ':tabnew vim.fn.expand("%:p")<Return>', opts)
map("n", "<leader><tab>n", ":tabnext<Return>", opts)
map("n", "<leader><tab>p", ":tabprev<Return>", opts)

-- window size
map("n", "(", ":res +1<Return>", opts)
map("n", ")", ":res -1<Return>", opts)

-- Split window
map("n", "<leader>wj", ":split<Return>", opts)
map("n", "<leader>wl", ":vsplit<Return>", opts)

-- move with through directories easier
map("n", "sz", ":Z ", { desc = "Zoxide" })

-- delete all buffers
map("n", "<Leader>ba", ":%bd<CR>", opts)

-- -- set the pine directory
map("n", "<leader>p", function()
  local path = require("oil").get_current_dir() or vim.fn.expand("%:p:h")
  require("utils.pineDir").setPineDir(path)
end, opts)

map("n", "<c-b>", function()
  vim.fn.chdir(vim.fn.expand("%:p:h"))
  print(vim.fn.getcwd())
end, { desc = "Set CWD to Buffer Directory" })

-- string replace
map("n", "<leader>rw", ":%s/<C-r>=expand('<cword>')<CR>//g<Left><Left>", { desc = "Replace Word" })
map("n", "<leader>ra", ":%s/<C-r>=expand('<cword>')<CR>/&/g<Left><Left>", { desc = "Append in Word" })
map("n", "<leader>ri", ":%s/<C-r>=expand('<cword>')<CR>/&/g<Left><Left><Left>", { desc = "Insert in Word" })

map("v", "<leader>rw", 'y:%s/<C-r><C-r>"//g<Left><Left>', { desc = "Replace Selection" })
map("v", "<leader>ra", 'y:%s/<C-r><C-r>"/&/g<Left><Left>', { desc = "Append In Selection" })
map("v", "<leader>ri", 'y:%s/<C-r><C-r>"/&/g<Left><Left><Left>', { desc = "Insert In Selection" })
map("v", "<leader>rs", ":s//g<Left><Left>", { desc = "Replace In Selection" })

map("c", "<C-f>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<right>", true, false, true), "m", true)
end, { noremap = true })

map("c", "<C-b>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<left>", true, false, true), "m", true)
end, { noremap = true })

map("c", "<C-a>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Home>", true, false, true), "m", true)
end, { noremap = true })

-- save and source
map("n", "<leader>S", ":w<CR>:source %<CR>", opts)

map("n", "<leader>N", ":R ")
map("n", "<leader>M", ":M ")
