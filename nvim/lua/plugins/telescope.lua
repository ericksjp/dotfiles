local function GrepFiles(dir)
  require("telescope.builtin").find_files({
    no_ignore = false,
    hidden = true,
    cwd = dir,
    mappings = {
      i = {
        ["<C-h>"] = require("telescope.actions").select_tab,
      },
    },
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
        GrepFiles(vim.fn.expand("%:p:h"))
      end,
      desc = "Lists files in the Current Buffer dir, respects .gitignore",
    },

    {
      "sk",
      function()
        GrepFiles(LazyVim.root())
      end,
      desc = "Lists files in your Root dir, respects .gitignore",
    },

    {
      "sj",
      function()
        GrepFiles(vim.fn.getcwd())
      end,
      desc = "Lists files in your CWD, respects .gitignore",
    },

    {
      "sl",
      function()
        GrepFiles(PineDir)
      end,
      desc = "Lists files in Pined Directory, respects .gitignore",
    },

    {
      "sg",
      function()
        local builtin = require("telescope.builtin")
        builtin.git_branches()
      end,
    },

    {
      "ss",
      desc = "String Finder",
    },

    {
      "ssh",
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep({
          cwd = vim.fn.expand("%:p:h"),
        })
      end,
      desc = "Search for a string in your current Buffer directory and get results live as you type, respects .gitignore",
    },

    {
      "ssk",
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep({
          cwd = LazyVim.root(),
        })
      end,
      desc = "Search for a string in your Root Dir and get results live as you type, respects .gitignore",
    },

    {
      "ssj",
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep({
          cwd = vim.fn.getcwd(),
        })
      end,
      desc = "Search for a string in your CWD and get results live as you type, respects .gitignore",
    },

    {
      "so",
      function()
        local builtin = require("telescope.builtin")
        builtin.buffers({
          mappings = {
            i = {
              ["<C-d>"] = require("telescope.actions").delete_buffer,
            },
            n = {
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
        local builtin = require("telescope.builtin")
        builtin.resume()
      end,
      desc = "Resume the previous telescope picker",
    },
    {
      "sd",
      function()
        local builtin = require("telescope.builtin")
        builtin.diagnostics()
      end,
      desc = "Lists Diagnostics for all open buffers or a specific buffer",
    },
    {
      "se",
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
      desc = "Lists Function names, variables, from Treesitter",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {
          ["<c-d>"] = require("telescope.actions").delete_buffer,
        }, -- n
        i = {
          ["c-d>"] = require("telescope.actions").delete_buffer,
          ["<c-t>"] = require("telescope.actions").select_tab,
        },
      },
    })
    opts.pickers = {
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
