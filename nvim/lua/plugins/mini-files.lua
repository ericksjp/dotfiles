local au_group = vim.api.nvim_create_augroup("__mini", { clear = true })

return {
  "echasnovski/mini.files",
  version = false,
  commit = "0db8f49088bcefff23c5cb8498a6c94e46a45a8e",
  enabled = true,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    { "antosha417/nvim-lsp-file-operations", dependencies = { "nvim-lua/plenary.nvim" } },
  },
  config = function()
    require("mini.files").setup({
      mappings = {
        close = "q",
        go_out = "e",
        go_out_plus = "<c-e>",
        go_in = "m",
        mark_set = "sm",
        -- mark_goto = "m",
        go_in_plus = "<enter>",
        synchronize = "<c-s>",
      },

      options = { permanent_delete = false, use_as_default_explorer = true },
    })

    local events = {
      ["lsp-file-operations.did-rename"] = { { "MiniFilesActionRename", "MiniFilesActionMove" }, "Renamed" },
      ["lsp-file-operations.will-create"] = { "MiniFilesActionCreate", "Create" },
      ["lsp-file-operations.will-delete"] = { "MiniFilesActionDelete", "Delete" },
    }

    for module, pattern in pairs(events) do
      vim.api.nvim_create_autocmd("User", {
        pattern = pattern[1],
        group = au_group,
        desc = string.format("Auto-refactor LSP file %s", pattern[2]),
        callback = function(event)
          local ok, action = pcall(require, module)
          if not ok then
            return
          end
          local args = {}
          local data = event.data
          if data.from == nil or data.to == nil then -- when the `pattern` is "create" or "delete"
            args = { fname = data.from or data.to }
          else
            args = { old_name = data.from, new_name = data.to }
          end
          action.callback(args)
        end,
      })
    end

    local show_dotfiles = true

    local filter_show = function(fs_entry)
      return true
    end

    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, ".")
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      MiniFiles.refresh({ content = { filter = new_filter } })
    end

    -----

    local map_split = function(buf_id, lhs, direction)
      local rhs = function()
        local cur_target = MiniFiles.get_explorer_state().target_window
        local new_target = vim.api.nvim_win_call(cur_target, function()
          vim.cmd(direction .. " split")
          return vim.api.nvim_get_current_win()
        end)

        MiniFiles.set_target_window(new_target)
      end
      local desc = "Split " .. direction
      vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
    end

    -----

    local function get_path(callback)
      local path = (MiniFiles.get_fs_entry() or {}).path
      if path == nil then
        return vim.notify("Cursor is not on valid entry")
      end
      callback(path)
    end

    local set_cwd = function()
      get_path(function(path)
        local result = vim.fs.dirname(path)
        vim.fn.chdir(result)
        MiniFiles.trim_left()
        MiniFiles.trim_right()
        vim.notify("Cwd: " .. result)
      end)
    end

    local yank_path = function()
      get_path(function(path)
        vim.fn.setreg(vim.v.register, path)
      end)
    end

    local open_tab = function()
      get_path(function(path)
        vim.cmd("tabnew " .. path)
      end)
    end

    local set_pined = function()
      get_path(function(path)
        path = vim.fn.isdirectory(path) == 1 and path or vim.fn.fnamemodify(path, ":h")
        require("utils.pined").set_pined(path)
      end)
    end

    local open_extern = function()
      get_path(function(path)
        vim.fn.jobstart('xdg-open "' .. path .. '"')
      end)
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local b = args.data.buf_id
        vim.keymap.set("n", "H", toggle_dotfiles, { buffer = b })
        map_split(b, "<C-j>", "belowright horizontal")
        map_split(b, "<C-l>", "belowright vertical")
        vim.keymap.set("n", ".", set_cwd, { buffer = b, desc = "Set cwd" })
        vim.keymap.set("n", "<c-y>", yank_path, { buffer = b, desc = "Yank path" })
        vim.keymap.set("n", "<c-t>", open_tab, { buffer = b, desc = "Yank path" })
        vim.keymap.set("n", "sp", set_pined, { buffer = b, desc = "Set Pined Directory" })
        vim.keymap.set("n", "se", open_extern, { buffer = b, desc = "Open Entry In Extern Program" })
        vim.keymap.set("n", "<tab>", function() require("utils.smart").MiniFiles(true) end, { buffer = b, desc = "Move over" })
      end,
    })

    --- # Set custom bookmarks
    -- local set_mark = function(id, path, desc)
    --   MiniFiles.set_bookmark(id, path, { desc = desc })
    -- end

    -- vim.api.nvim_create_autocmd("User", {
    --   pattern = "MiniFilesExplorerOpen",
    --   callback = function()
    --     set_mark("r", LazyVim.root(), "Root Directory")
    --     set_mark("w", vim.fn.getcwd, "Working directory")
    --     set_mark("p", require("utils.pined").get_pined, "Pined Directory")
    --     -- set_mark("b", vim.fn.expand('%:p'), "Buffer Directory")
    --     set_mark("c", vim.fn.stdpath("config"), "Config")
    --     set_mark("~", "~", "Home directory")
    --   end,
    -- })

  end,
}
