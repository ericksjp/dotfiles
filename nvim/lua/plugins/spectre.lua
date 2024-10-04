return {
  "nvim-pack/nvim-spectre",
  config = function()
    require("spectre").setup({
      mapping = {
        ["run_replace"] = {
          map = "<c-j>",
          cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
          desc = "replace all",
        },
      },
    })
  end,
  keys = function()
    local function spectreOpen(dir, text)
      text = text or vim.fn.expand("<cword>")
      require("spectre").open({
        is_insert_mode = true,
        cwr = dir,
        search_text = text,
      })

      vim.defer_fn(function()
        vim.cmd("5")
        local buffrn = vim.api.nvim_get_current_buf()
        vim.keymap.set("i", "<c-j>", function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc><c-j>", true, false, true), "m", true)
        end, { buffer = buffrn })
      end, 100)
    end

    local function getVText()
      vim.cmd("normal! y")
      return vim.fn.getreg('"')
    end

    -- Mapeamento para o modo visual usando a função criada
    vim.keymap.set("v", "<leader>rc", function()
      spectreOpen(vim.fn.getcwd(), getVText())
    end, { desc = "Search on current directory" })

    return {
      {
        "<leader>rc",
        function()
          spectreOpen(vim.fn.getcwd())
        end,
        desc = "Spectre - Current directory",
      },
      {
        "<leader>rr",
        function()
          spectreOpen(LazyVim.root)
        end,
        desc = "Spectre - Root directory",
      },
      {
        "<leader>rb",
        function()
          spectreOpen(vim.fn.expand("%:p:h"))
        end,
        desc = "Spectre - Buffer directory",
      },

      {
        "<leader>rc",
        function()
          spectreOpen(vim.fn.getcwd(), getVText())
        end,
        mode = "v",
        desc = "Spectre - Current directory (visual)",
      },
      {
        "<leader>rr",
        function()
          spectreOpen(LazyVim.root, getVText())
        end,
        mode = "v",
        desc = "Spectre - Root directory (visual)",
      },
      {
        "<leader>rb",
        function()
          spectreOpen(vim.fn.expand("%:p:h"), getVText())
        end,
        mode = "v",
        desc = "Spectre - Buffer directory (visual)",
      },
    }
  end,
}
