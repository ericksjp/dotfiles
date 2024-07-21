local function GrepFiles(dir)
  require("telescope.builtin").find_files({
    no_ignore = false,
    hidden = true,
    cwd = dir,
    -- layout_config = { prompt_position = "top", width = 0.95, preview_width = 0.6 },
  })
end

return {
  "telescope.nvim",
  priority = 1000,
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    {
      "sh",
      function()
        local dir = require("oil").get_current_dir() or vim.fn.expand("%:p:h")
        GrepFiles(dir)
      end,
      desc = "Lists files in the Current Buffer dir, respects .gitignore",
    },

    {
      "sj",
      function()
        GrepFiles(vim.fn.getcwd())
      end,
      desc = "Lists files in your CWD, respects .gitignore",
    },

    {
      "sk",
      function()
        GrepFiles(LazyVim.root())
      end,
      desc = "Lists files in your Root dir, respects .gitignore",
    },

    {
      "sl",
      function()
        GrepFiles(PineDir)
      end,
      desc = "Lists files in Pined Directory, respects .gitignore",
    },

    { "ss", "", desc = "Grep String", mode = { "n" } },
    {
      "ssh",
      function()
        require("telescope.builtin").live_grep({
          cwd = require("oil").get_current_dir() or vim.fn.expand("%:p:h"),
          -- layout_config = { prompt_position = "top", width = 0.95, preview_width = 0.6 },
        })
      end,
      desc = "Search for a string in your current Buffer directory and get results live as you type, respects .gitignore",
    },

    {
      "ssk",
      function()
        require("telescope.builtin").live_grep({
          cwd = LazyVim.root(),
        })
      end,
      desc = "Search for a string in your Root Dir and get results live as you type, respects .gitignore",
    },

    {
      "ssj",
      function()
        require("telescope.builtin").live_grep({
          cwd = vim.fn.getcwd(),
        })
      end,
      desc = "Search for a string in your CWD and get results live as you type, respects .gitignore",
    },

    {
      "ssl",
      function()
        require("telescope.builtin").live_grep({
          cwd = PineDir,
        })
      end,
      desc = "Search for a string in your Pine Dir and get results live as you type, respects .gitignore",
    },

    {
      "so",
      function()
        require("telescope.builtin").buffers({
          mappings = {
            i = {
              ["<C-d>"] = require("telescope.actions").delete_buffer,
            },
          },
        })
      end,
      desc = "Lists open buffers",
    },
    {
      "sq",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Resume the previous telescope picker",
    },
    {
      "sd",
      function()
        require("telescope.builtin").diagnostics()
      end,
      desc = "Lists Diagnostics for all open buffers or a specific buffer",
    },
    {
      "se",
      function()
        require("telescope.builtin").treesitter()
      end,
      desc = "Lists Function names, variables, from Treesitter",
    },
    {
      "sn",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find({
          layout_config = {
            preview_width = 0.3,
          },
        })
      end,
      desc = "Search in current buffer",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top", width = 0.95 },
      sorting_strategy = "ascending",
      winblend = 0,
      file_ignore_patterns = {
        "^.git/",
        "^node_modules/",
      },
      mappings = {
        n = {
          ["<C-d>"] = actions.delete_buffer,
        }, -- n
        i = {
          ["<C-d>"] = actions.close,
          ["<C-c>"] = false,
          ["<c-t>"] = actions.select_tab,
          ["<c-k>"] = actions.preview_scrolling_up,
          ["<c-j>"] = actions.preview_scrolling_down,
          ["<c-h>"] = actions.preview_scrolling_left,
          ["<c-l>"] = actions.preview_scrolling_right,
        },
      },
    })
    opts.pickers = {
      find_files = {
        layout_config = { preview_width = 0.6 },
      },
      live_grep = {
        layout_config = { preview_width = 0.5 },
      },
      buffers = {
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer,
          },
        },
      },
      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
        layout_config = {
          preview_cutoff = 9999,
        },
      },
    }
    telescope.setup(opts)
    require("telescope").load_extension("fzf")
  end,
}
