local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- delete without copy
keymap.set("n", "x", '"_x')
keymap.set("n", ",", '"_')

-- super super s
keymap.set("n", "s", function()
  require("which-key").show("s")
end)

opts.desc = "Save all"
keymap.set("n", "<leader>za", ":wa<cr>", opts)
opts.desc = "Save and quit"
keymap.set("n", "<leader>zq", ":qa<cr>", opts)
opts.desc = "Save and quit"
keymap.set("n", "<leader>zx", ":wq<cr>", opts)
opts.desc = "Save and quit"
keymap.set("n", "<leader>zo", ":q!<cr>", opts)
opts.desc = nil

-- marks
-- list marks
keymap.set("n", "<leader>m", function()
  local marks = vim.fn.execute("marks")
  local alpha_marks = {}

  for line in marks:gmatch("[^\r\n]+") do
    local mark = line:match("^%s*([a-z])%s+")
    if mark then
      table.insert(alpha_marks, line)
    end
  end

  require("fzf-lua").fzf_exec(alpha_marks, {
    prompt = "Marks> ",
    winopts = { height = 0.5, width = 0.5 },
    previewer = false,
    fzf_opts = {
      ["--pointer"] = "|",
    },
    actions = {
      ["default"] = function(selected)
        local mark = selected[1]:sub(2, 2)
        if mark then
          vim.cmd("normal! g`" .. mark)
        end
      end,
    },
  })
end, { desc = "List Marks" })
-- go to mark
keymap.set("n", "M", function()
  local key = vim.fn.getchar()
  local char = vim.fn.nr2char(key)

  if char == "," then
    return vim.cmd("normal! [`")
  elseif char == "." then
    return vim.cmd("normal! ]`")
  end

  vim.cmd("normal! g`" .. char)
end)
-- delete mark
keymap.set("n", "dm", function()
  local key = vim.fn.getchar()
  local char = vim.fn.nr2char(key)

  vim.cmd("delmark " .. char)
end, { desc = "Delete Mark" })
-- delete all marks
keymap.set("n", "dM", ":delmarks a-z<CR>", { desc = "Delete All Marks" })

-- toggle terminal
keymap.set("n", "<c-\\>", function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })
keymap.set("t", "<c-\\>", "<cmd>close<cr>", { desc = "Hide Terminal" })

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

keymap.set("i", "<C-f>", function()
  require("flash").jump()
end, opts)

keymap.set("n", "<C-c>", ":qa<CR>", opts)

-- Tabs
keymap.set("n", "<tab>", ":tabnext<Return>", opts)

-- Split window
keymap.set("n", "<leader>wh", ":split<Return>", opts)
keymap.set("n", "<leader>wv", ":vsplit<Return>", opts)

-- navigate through buffers
keymap.set("n", "L", ":bnext<CR>", opts)
keymap.set("n", "H", ":bprev<CR>", opts)

-- enter the cmd easier
keymap.set("n", "<C-x>", ": <backspace>")
keymap.set("v", "<C-x>", ": <backspace>")

-- move with through directories easier
keymap.set("n", "çc", ":cd ")
keymap.set("n", "çs", ":Z ")

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
