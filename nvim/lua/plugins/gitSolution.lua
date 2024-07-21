return {
  {
    "tpope/vim-fugitive",
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed, not both.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua", -- optional
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
      local ng = require("neogit")

      -- for some reason this maps dont work in the table
      vim.keymap.set("n", "<leader>jl", ng.action("log", "log_current", {}), { desc = "Show Commits" })
      vim.keymap.set("n", "<leader>jC", ng.action("commit", "commit", { "--verbose", "--all" }), { desc = "Commit" })

      return {
        {
          "<C-g>",
          function()
            ng.open({})
          end,
          desc = "Open Neogit",
        },
        { "<Leader>j", "", desc = "Git Commands", mode = { "n" } },
        {
          "<Leader>jc",
          function()
            ng.open({ "commit" })
          end,
          desc = "Commit changes",
        },
        {
          "<Leader>jp",
          function()
            ng.open({ "pull" })
          end,
          desc = "Pull changes",
        },
        {
          "<Leader>je",
          function()
            ng.open({ "push" })
          end,
          desc = "Push changes",
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
          map({ "n", "v" }, "<leader>ks", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
          map({ "n", "v" }, "<leader>kr", ":Gitsigns reset_hunk<CR>", { desc = "Reset hunk" })
          map("n", "<leader>kS", gs.stage_buffer, { desc = "Stage buffer" })
          map("n", "<leader>ka", gs.stage_hunk, { desc = "Stage hunk" })
          map("n", "<leader>ku", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
          map("n", "<leader>kR", gs.reset_buffer, { desc = "Reset buffer" })
          map("n", "<leader>kp", gs.preview_hunk, { desc = "Preview hunk" })
          map("n", "<leader>kb", function()
            gs.blame_line({ full = true })
          end, { desc = "Blame line" })
          map("n", "<leader>kl", gs.toggle_current_line_blame, { desc = "Toggle current line blame" })
          map("n", "<leader>kd", gs.diffthis, { desc = "Diff this" })
          map("n", "<leader>kD", function()
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
        "<Leader>jk",
        function()
          require("telescope.builtin").git_commits({
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.99,
              preview_width = 0.6,
            },
          })
        end,
        silent = true,
        noremap = true,
        desc = "List commits on Telescope",
      },

      {
        "<Leader>jb",
        function()
          require("telescope.builtin").git_branches({
            layout_strategy = "horizontal",
            layout_config = {
              width = 0.99,
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
