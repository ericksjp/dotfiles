local map = vim.keymap.set
local opts = { noremap = true, silent = true }
local sm = require("utils.smart")
local funcs = require("utils.functions")
local marks = require("utils.marks")
local scan = require("plenary.scandir")

map("n", "x", '"_x')
map("n", ";", '"_')
map("v", "p", '"_dP')
map({ "n", "v" }, "ç", ":")
map({ "n", "v" }, "<c-q>", ":!")
map("n", "n", "nzz", opts)
map("n", "<esc>", "<esc>:noh<cr>", opts)
map("n", "<c-a>", "gg<S-v>G")
map("n", "<C-c>", ":qa<CR>", opts)
map("n", "t", "@")
map("n", "<leader>S", ":w<CR>:source %<CR>", opts)
map("i", "<c-d>", "<esc>:$<cr>", { noremap = true, silent = true })

-- resize
map("n", "<M-k>", function()
    require("tmux").resize_top()
end, { silent = true })
map("n", "<M-j>", function()
    require("tmux").resize_bottom()
end, { silent = true })

map("n", "<C-n>", ":bn<CR>", opts)
map("n", "<C-p>", ":bp<CR>", opts)

-- Increment/decrement
map({ "n", "v" }, "+", "<C-a>")
map({ "n", "v" }, "-", "<C-x>")
map("v", "<C-a>", "")
map("v", "<C-b>", "")

-- -- hold s
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
-- map("n", "<leader><tab><tab>", ":tabnew<cr>", { silent = true, desc = "New tab" })
map("n", "<leader><Tab>n", ":tabnext<cr>", { silent = true, desc = "Next tab", noremap = true })
map("n", "<Tab>", ":tabnext<cr>", { silent = true, desc = "Next tab", noremap = true })
map("n", "<leader><Tab>p", ":tabprev<cr>", { silent = true, desc = "Prev tab", noremap = true })
-- map("n", "<localleader><tab>", ":tabnext<cr>", { silent = true, desc = "Next tab", noremap = true })
-- map("n", "<c-]>", ":tabprev<cr>", { silent = true, desc = "Prev tab" })

-- map("n", "<C-space>", "<Plug>VimwikiNextLink", { silent = true, noremap = true})

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
map("n", "<localleader>s", ":%s//g" .. left(2), { desc = "String replace" })
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

-- dadbod
map("n", "<leader>D", ":DBUIToggle<cr>", { desc = "Toggle dadbod-ui", silent = true })

-- obsession
map("n", "<leader>os", function()
    local path = vim.fn.getcwd() .. "/.vim"
    if vim.fn.filereadable(path .. "/Session.vim") == 0 then
        vim.fn.mkdir(path, "p")
        vim.cmd("Obsession " .. path)
        vim.notify("Tracking session in .vim/Session.vim", "info")
    else
        vim.cmd("Obsession")
        local stats = vim.fn.ObsessionStatus() == "[S]" and "Pausing " or "Tracking "
        vim.notify(stats .. "session in .vim/Session.vim", "info")
    end
end, { desc = "Toggle obsession tracking" })

map("n", "<leader>od", function()
    local sessionFile = vim.fn.getcwd() .. "/.vim/Session.vim"
    if vim.fn.filereadable(sessionFile) == 1 then
        vim.cmd("Obsession!")
        vim.notify("Obsession file deleted", "info")
    else
        vim.notify("No obsession file found", "error")
    end
end, { silent = true, desc = "Delete obsession file" })

-- -- leap
-- map("n", "f", "<Plug>(leap)", opts)
-- map("n", "F", "<Plug>(leap-from-window)", opts)
-- map({ "x", "o" }, "f", "<Plug>(leap-forward)", opts)
-- map({ "x", "o" }, "F", "<Plug>(leap-backward)", opts)

map({ "o", "x" }, "s", "<Plug>(nvim-surround-visual)", opts)
map({ "o", "x" }, "S", "<Plug>(nvim-surround-visual-line)", opts)

map({ "n", "x", "o" }, "f", function()
    require("flash").jump()
end, { desc = "Flash" })
map({ "n", "x", "o" }, "F", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
    require("flash").remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
end, { desc = "Treesitter Search" })
-- map({ "c" },"<c-f>", function() require("flash").toggle() end, {desc = "Toggle Flash Search" })
map({ "i" }, "<c-e>", '<C-o><Cmd>lua require("flash").jump()<cr>', { desc = "" })

-- -- Mini.files
-- map( "n", "<leader>e", function() sm.MiniFiles(false) end, { desc = "Open MiniFiles", silent = true })
map("n", "<leader>fe", function()
    sm.Neotree(false)
end, { desc = "Open Neotree", silent = true })
map("n", "<leader>e", function()
    sm.Oil(false)
end, { desc = "Open MiniFiles", silent = true, noremap = true })
-- map("n", "<leader>fe", function() Snacks.explorer() end, { desc = "Open Explorer", silent = true, noremap = true })

-------telescope
map("n", "<leader><leader>", function()
    sm.FindFile(false)
end, { desc = "Find File" })

-- map("n", "<leader>m", function() Snacks.picker.smart({layout = "select"}) end, { desc = "Smart" })

-- map("n", "<leader><leader>", function()
--   Snacks.picker.smart();
-- end, { desc = "Find File" })

map("n", "<leader>cd", function()
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

-- snacks

map("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition" })
map("n", "gD", function()
    Snacks.picker.lsp_declarations()
end, { desc = "Goto Declaration" })
map("n", "gr", function()
    Snacks.picker.lsp_references()
end, { nowait = true, desc = "References" })
map("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation" })
map("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition" })
map("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols" })
map("n", "<leader>sS", function()
    Snacks.picker.lsp_workspace_symbols()
end, { desc = "LSP Workspace Symbols" })

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

--- --- copilot
-- map("i", "<tab>", function()
--   if require("copilot.suggestion").is_visible() then
--     require("copilot.suggestion").accept()
--   else
--     local termcodes = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
--     vim.api.nvim_feedkeys(termcodes, "n", false)
--   end
-- end, { noremap = true })

-- require("copilot.command").disable()
local copilot_enabled = false
local copilot_not_loaded = true
Snacks.toggle({
    name = "Copilot",
    get = function()
        return copilot_enabled
    end,
    set = function()
        if copilot_not_loaded then
            require("plugins.copilot").config()
            copilot_not_loaded = false
        end

        copilot_enabled = not copilot_enabled
        if copilot_enabled then
            require("copilot.command").enable()
        else
            require("copilot.command").disable()
        end
    end,
}):map("<leader>uo")

-- nvim cmp
vim.b.completion = true
Snacks.toggle({
  name = "Completion",
  get = function()
    return vim.b.completion
  end,
  set = function(state)
    vim.b.completion = not state
  end,
}):map("<leader>uc")

-- i dont care anymore
map("n", "<leader>of", function()
    Snacks.zen.zen({
        win = {
            width = 0,
        },
    })
end, {})

map("n", "<leader>op", function()
    Snacks.zen.zen({
        window = {
            width = 0.5,
        },
    })
end, {})

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

    -- map("n", "<leader>r", function()
    --   harpoon:list():remove()
    --   print("Removed from Harpoon List")
    -- end, { desc = "Delete Buffer From Harpoon List" })

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

map("n", "\\", function()
    Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "Lazygit (Root Dir)" })
-- map("n", "<C-g>", ":Git ", { desc = "Do Git" })
-- map("n", "<leader>vv", ":tab Git <CR>", { desc = "Do Git" })
-- map("n", "<leader>vc", ":tab Git commit -v <CR>", { desc = "Git commit with verbose thing", silent = true })

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

map({ "n", "x", "o" }, "f", function()
    require("flash").jump()
end, { desc = "Flash" })
map({ "n", "o", "x" }, "F", function()
    require("flash").treesitter()
end, { desc = "Flash Treesitter" })
map("o", "r", function()
    require("flash").remote()
end, { desc = "Remote Flash" })
map({ "o", "x" }, "R", function()
    require("flash").treesitter_search()
end, { desc = "Treesitter Search" })

map("n", "<leader>vf", function()
    vim.ui.input({
        prompt = "Vault Name: ",
    }, function(vault_name)
        if not vault_name or vault_name == "" then
            return
        end

        local vault_base = "/home/erick/vaults/notes"
        local vault_path = vault_base .. "/" .. vault_name

        if vim.fn.isdirectory(vault_path) == 0 then
            vim.fn.mkdir(vault_path, "p")
            vim.notify("Vault created: " .. vault_path, "info")
        else
            vim.notify("Vault already exists: " .. vault_path, "error")
        end
    end)
end)

map("n", "<leader>vip", ":ObsidianPasteImg<cr>", opts)

map("n", "<leader>vn", function()
    local vault_base = "/home/erick/vaults/notes"

    -- Step 1: list vaults (folders)
    local vaults = scan.scan_dir(vault_base, { only_dirs = true, depth = 1 })

    local vault_names = vim.tbl_map(function(path)
        return vim.fn.fnamemodify(path, ":t") -- just folder name
    end, vaults)

    vim.ui.select(vault_names, { prompt = "Choose vault:" }, function(vault)
        if not vault then
            return
        end

        -- Step 2: prompt for note name
        vim.ui.input({ prompt = "Note title: " }, function(title)
            if not title or title == "" then
                return
            end
            local dir = vault_base .. "/" .. vault
            if vim.fn.isdirectory(dir) == 0 then
                vim.fn.mkdir(dir, "p")
            end

            local existing = vim.split(vim.fn.glob(dir .. "/*.md"), "\n", { trimempty = true })
            local index = #existing + 1
            local index2digit = string.format("%02d", index)

            local filename = index2digit .. "-" .. title .. ".md"
            local fullpath = dir .. "/" .. filename

            local id = index2digit .. "-" .. title
            local date = os.date("%d-%m-%Y")
            local tag = vault

            local content = {
                "---",
                "id: " .. id,
                "aliases: []",
                "tags:",
                "  - " .. tag,
                'date: "' .. date .. '"',
                "---",
                "",
                "# " .. title,
                "",
            }

            vim.fn.writefile(content, fullpath)
            vim.cmd("edit " .. fullpath)
            vim.cmd("normal! G")
            vim.cmd("startinsert")
            vim.notify("New note created: " .. fullpath, "info")
        end)
    end)
end, { desc = "Obsidian new note" })

-- other stuff
require("utils.fileWatcher"):setup()
require("utils.pined").load_pined()
