return {
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("neogit").setup({
        mappings = {
          commit_editor = {
            ["q"] = "Close",
            ["<c-j><c-j>"] = "Submit",
            ["<c-j><c-k>"] = "Abort",
          },
        },
      })
    end,
    keys = function()
      return {
        {
          "<C-g>",
          function()
            require("neogit").open({})
          end,
          desc = "Open Neogit",
        },
        {
          "<leader>gg",
          function()
            require("neogit").open({})
          end,
          desc = "Open Neogit",
        },
      }
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        current_line_blame = false,
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          -- Actions
          map({ "n", "v" }, "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
          map({ "n", "v" }, "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
          map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>ga", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>gb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>gl", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
          map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>gD", function()
            gs.diffthis("~")
          end, { desc = "Diff this (cached)" })

          -- Text object
          map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>") -- Text object
        end,
      })
    end,
  },
  {
    "telescope.nvim",
    keys = {
      {
        "sgc",
        function()
          require("telescope.builtin").git_commits({
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.9,
              preview_width = 0.6,
            },
          })
        end,
        silent = true,
        noremap = true,
        desc = "List commits on Telescope",
      },

      {
        "sgb",
        function()
          require("telescope.builtin").git_branches({
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.9,
              preview_width = 0.6,
            },
          })
        end,
        silent = true,
        noremap = true,
        desc = "List branches on Telescope",
      },
    },
  },
}
