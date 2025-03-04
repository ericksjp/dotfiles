local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local sm = require("utils.smart")
local funcs = require("utils.functions")
local marks = require("utils.marks")

map("n", "x", '"_x')
map("n", ";", '"_')
map({ "n", "v" }, "ç", ":")
map({ "n", "v" }, "<C-q>", ":!")
map("n", "n", "nzz", opts)
map("n", "<esc>", "<esc>:noh<cr>", opts)
map("n", "<c-a>", "gg<S-v>G")
map("n", "<C-c>", ":qa<CR>", opts)
map("n", "t", "@")
map("n", "<leader>S", ":w<CR>:source %<CR>", opts)

-- Increment/decrement
map({ "n", "v" }, "+", "<C-a>")
map({ "n", "v" }, "-", "<C-x>")
map("v", "<C-a>", "")
map("v", "<C-b>", "")

map("n", "<C-p>", ":bprev<cr>", opts)
map("n", "<C-n>", ":bnext<cr>", opts)

-- hold s
map("n", "s", function()
  require("which-key").show("s")
end)

-- marks
map("n", "m", function()
  marks.gotoMark()
end, { silent = true, desc = "Go To Mark" })
map("n", "sm", function()
  marks.putMark()
end, { silent = true, desc = "Put Mark" })
map("n", "dm", function()
  marks.delMark()
end, { silent = true, desc = "Delete Mark" })

-- Tabs
map("n", "<leader><tab><tab>", ":tabnew<cr>", { silent = true, desc = "New tab" })
map("n", "<Tab>", ":tabnext<cr>", { silent = true, desc = "Next tab" })
-- map("n", "<c-]>", ":tabprev<cr>", { silent = true, desc = "Prev tab" })

-- Split window
map("n", "<leader>wj", ":split<cr>", opts)
map("n", "<leader>wl", ":vsplit<cr>", opts)

-- string replace
local function left(num) -- helper function to add <Left> to the end of the string
  return string.rep("<Left>", num)
end

map("n", "<localleader>w", ":%s/<C-r>=expand('<cword>')<CR>//g" .. left(2), { desc = "Replace Word" })
map("n", "<localleader>a", ":%s/<C-r>=expand('<cword>')<CR>/&/g" .. left(2), { desc = "Append in Word" })
map("n", "<localleader>i", ":%s/<C-r>=expand('<cword>')<CR>/&/g" .. left(3), { desc = "Insert in Word" })
map("n", "<localleader>s", ":%s///g" .. left(3), { desc = "String replace" })
map("v", "<localleader>w", 'y:%s/<C-r><C-r>"//g' .. left(2), { desc = "Replace Selection" })
map("v", "<localleader>a", 'y:%s/<C-r><C-r>"/&/g' .. left(2), { desc = "Append In Selection" })
map("v", "<localleader>i", 'y:%s/<C-r><C-r>"/&/g' .. left(3), { desc = "Insert In Selection" })
map("v", "<localleader>s", ":s//g" .. left(2), { desc = "Replace In Selection" })

map({ "n", "v" }, "<localleader>q", function()
  local word = funcs.get_word()
  vim.cmd(":vimgrep /" .. word .. "/g % | copen")
  funcs.set_qf_word(word)
end, { desc = "Open qflist with selected string", silent = true })

-- easier navigation on cmd
map("c", "<C-f>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<right>", true, false, true), "m", true)
end, { noremap = true })

map("c", "<C-b>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<left>", true, false, true), "m", true)
end, { noremap = true })

map("c", "<C-a>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Home>", true, false, true), "m", true)
end, { noremap = true })

-- easier navigation on insert mode
map("i", "<C-f>", "<Right>", opts)
map("i", "<C-b>", "<left>", opts)

-- markdown preview
map("n", "<leader>mp", ":MarkdownPreviewToggle<cr>", { desc = "Markdown Preview", silent = true })

-- leap
map("n", "f", "<Plug>(leap)", opts)
map("n", "F", "<Plug>(leap-from-window)", opts)
map({ "x", "o" }, "f", "<Plug>(leap-forward)", opts)
map({ "x", "o" }, "F", "<Plug>(leap-backward)", opts)

-- Mini.files
map(
  "n",
  "<leader>e",
  function()sm.MiniFiles(false)end,
  { desc = "Open MiniFiles", silent = true }
)

--telescope
map("n", "<leader><leader>", function()
  sm.FindFile(false)
end, { desc = "Find File" })

map("n", "<leader>fd", function()
  require("telescope").extensions.zoxide.list(require("telescope.themes").get_ivy({
    layout_config = {
      height = 0.9,
    },
  }))
end, { desc = "Find Zoxide Directories" })

map("n", "<leader>fs", function()
  sm.GrepString(false)
end, { desc = "Find String" })

map({ "n", "v" }, "<leader>sf", function()
  sm.GrepString(false, funcs.get_word())
end, { desc = "Grep String" })

map("n", "<leader>fm", function()
  marks.delAutoMarks()
  require("telescope.builtin").marks()
end, { desc = "Find Mark" })

-- tailwindcss
local tailwind_conceal = true
Snacks.toggle({
  name = "Tailwind Conceal",
  get = function()
    return tailwind_conceal
  end,
  set = function()
    tailwind_conceal = not tailwind_conceal
    vim.cmd("TailwindConcealToggle")
  end,
}):map("<leader>ut")

--- copilot
map("i", "<tab>", function()
  if require("copilot.suggestion").is_visible() then
    require("copilot").accept()
  else
    local termcodes = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
    vim.api.nvim_feedkeys(termcodes, "n", false)
  end
end, { noremap = true })

require("copilot.command").disable()
local copilot_enabled = false
Snacks.toggle({
  name = "Copilot",
  get = function()
    return copilot_enabled
  end,
  set = function()
    copilot_enabled = not copilot_enabled
    if copilot_enabled then
      require("copilot.command").enable()
    else
      require("copilot.command").disable()
    end
  end,
}):map("<leader>uo")

-- nvim cmp
local cmp_enabled = true
Snacks.toggle({
  name = "Completion",
  get = function()
    return cmp_enabled
  end,
  set = function()
    cmp_enabled = not cmp_enabled
    require("cmp.config").set_global({
      completion = {
        autocomplete = cmp_enabled and { "TextChanged" } or false,
      },
    })
  end,
}):map("<leader>uc")

-- copilot chat
map("n", "<leader>i", "", { desc = "+ai" })

map("n", "<leader>is", ":CopilotChatVisual<cr>", { silent = true, desc = "CopilotChat - Open in vertical split" })
map("n", "<leader>if", ":CopilotChatInline<cr>", { silent = true, desc = "CopilotChat - Open in float window" })
map("n", "<C-u>", ":CopilotChatInline<cr>", { silent = true, desc = "CopilotChat - Open in float window" })

map({ "n", "v" }, "<leader>ip", function()
  local mode = vim.fn.mode()
  local actions = require("CopilotChat.actions")
  local tsi = require("CopilotChat.integrations.telescope")
  if mode == "n" then
    tsi.pick(actions.prompt_actions())
  else
    tsi.pick(actions.prompt_actions({ selection = require("CopilotChat.select").visual }))
  end
end, { desc = "CopilotChat - Prompt actions" })

map({ "n", "v" }, "<leader>ia", function()
  local mode = vim.fn.mode()
  local input = vim.fn.input("Ask Copilot: ")
  if input ~= "" then
    if mode == "n" then
      vim.cmd("CopilotChat " .. input)
    else
      require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
    end
  end
end, { desc = "CopilotChat - Ask Copilot" })

-- harpoon
local function harpoonMap()
  local harpoon = require("harpoon")
  map("n", "<leader>a", function()
    harpoon:list():add()
    print("Add to Harpoon List")
  end, { desc = "Add Buffer to Harpoon List" })

  map("n", "<leader>r", function()
    harpoon:list():remove()
    print("Removed from Harpoon List")
  end, { desc = "Delete Buffer From Harpoon List" })

  map("n", "<leader>h", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, { desc = "Open Harpoon Quick Menu" })

  map("n", "<c-f>", function()
    harpoon:list():next({ ui_nav_wrap = true })
  end, { desc = "Next Buffer on Harpoon List" })

  map("n", "<c-e>", function()
    harpoon:list():prev({ ui_nav_wrap = true })
  end, { desc = "Previous Buffer on Harpoon List" })
end
harpoonMap()

map("n", "\\", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
map("n", "<C-g>", ":Git ", { desc = "Do Git" })

-- tmux
local function tmuxMap()
  local t = require("tmux")

  map("n", "<C-l>", function()
    t.move_right()
  end, { desc = "Move Right" })
  map("n", "<C-h>", function()
    t.move_left()
  end, { desc = "Move Right" })
  map("n", "<C-j>", function()
    t.move_bottom()
  end, { desc = "Move Bottom" })
  map("n", "<C-k>", function()
    t.move_top()
  end, { desc = "Move Top" })
end
tmuxMap()

-- other stuff
require("utils.fileWatcher"):setup()
require("utils.pined").load_pined()
