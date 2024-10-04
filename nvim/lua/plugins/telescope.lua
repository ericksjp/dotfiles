local function GrepFiles(dir, name)
  require("telescope.builtin").find_files({
    no_ignore = false,
    hidden = true,
    cwd = dir,
    prompt_title = "Find Files (" .. name .. ")",
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
      "ss",
      function()
        GrepFiles(vim.fn.getcwd(), "CWD")
      end,
      desc = "Find files (cwd)",
    },
    {
      "s<leader>",
      function()
        GrepFiles(LazyVim.root(), "Root Dir")
      end,
      desc = "List files (Root Dir)",
    },
    {
      "sb",
      function()
        local bufname = require("oil").get_current_dir() or vim.fn.expand("%:p:h")
        GrepFiles(bufname, "Buffer Dir")
      end,
      desc = "Find files (buffer dir)",
    },
    {
      "sp",
      function()
        GrepFiles(require("utils.pineDir").getPineDir(), "Pine Dir")
      end,
      desc = "List files (Pine Dir)",
    },
    {
      "sn",
      function()
        GrepFiles("~/notes", "Buffer Dir")
      end,
      desc = "Find files (Notes dir)",
    },

    {
      "sff",
      function()
        require("telescope.builtin").live_grep({
          cwd = vim.fn.getcwd(),
        })
      end,
      desc = "Search for a string in your CWD and get results live as you type, respects .gitignore",
    },
    {
      "sf<leader>",
      function()
        require("telescope.builtin").live_grep({
          cwd = LazyVim.root(),
        })
      end,
      desc = "Search for a string in your Root Dir and get results live as you type, respects .gitignore",
    },
    {
      "sfb",
      function()
        local bufname = vim.fn.expand("%:p:h")
        if bufname:match("^oil://*") ~= nil then
          bufname = require("oil").get_current_dir() .. ""
        end
        require("telescope.builtin").live_grep({
          cwd = bufname,
        })
      end,
      desc = "Search for a string in your current Buffer directory and get results live as you type, respects .gitignore",
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
      "sr",
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
      "sl",
      function()
        require("telescope.builtin").treesitter()
      end,
      desc = "Lists Function names, variables, from Treesitter",
    },
    {
      "sy",
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = LazyVim.config.get_kind_filter(),
        })
      end,
      desc = "Goto Symbol",
    },
    {
      "sm",
      function()
        require("telescope.builtin").lsp_document_symbols({})
      end,
      desc = "Lists all symbols in the current buffer",
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_results = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
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
        layout_config = { preview_width = 0, width = 0.5 },
      },
      live_grep = {
        layout_config = { preview_width = 0.6 },
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
