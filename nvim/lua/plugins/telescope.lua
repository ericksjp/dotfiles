local sm = require("utils.smart")

return {
  "telescope.nvim",
  priority = 1000,
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    "nvim-telescope/telescope-file-browser.nvim",
    "jvgrootveld/telescope-zoxide",
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local z_utils = require("telescope._extensions.zoxide.utils")
    local ivy = require("telescope.themes").get_ivy({
      layout_config = {
        height = 0.9,
      },
    })

    local function fixed_qlist(prompt_bufnr)
      local current_line = vim.b.telescope_grep_string_query or action_state.get_current_line()
      actions.smart_send_to_qflist(prompt_bufnr)
      actions.open_qflist(prompt_bufnr)
      vim.b.word = current_line
    end

    opts.defaults = vim.tbl_deep_extend("force", ivy, {
      sorting_strategy = "ascending",
      layout_config = { prompt_position = "top" },
      prompt_prefix = "   ",
      winblend = 0,
      wrap_results = true,
      file_ignore_patterns = {
        "^.git/",
        "^node_modules/",
        "^.github/",
        "^vendor/",
        "^target/",
      },
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-c>"] = actions.close,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<C-u>"] = false,
          ["<c-t>"] = actions.select_tab,
          ["<c-k>"] = actions.preview_scrolling_up,
          ["<c-j>"] = actions.preview_scrolling_down,
          ["<c-h>"] = actions.preview_scrolling_left,
          ["<c-l>"] = actions.preview_scrolling_right,
          ["<c-a>"] = actions.toggle_selection + actions.move_selection_next,
        },
      },
    })

    opts.pickers = {
      theme = "ivy",
      help_tags = {
        theme = "ivy",
      },
      find_files = {
        theme = "ivy",
        hidden = false,
        layout_config = {
          height = 0.9,
        },
        mappings = {
          i = {
            ["<tab>"] = function()
              sm.FindFile(true)
            end,
          },
        },
      },
      live_grep = {
        theme = "ivy",
        layout_config = {
          height = 0.9,
        },
        mappings = {
          i = {
            ["<C-q>"] = fixed_qlist,
            ["<tab>"] = function()
              sm.GrepString(true)
            end,
          },
        },
      },

      grep_string = {
        theme = "ivy",
        layout_config = {
          height = 0.9,
        },
        mappings = {
          i = {
            ["<C-q>"] = fixed_qlist,
            ["<tab>"] = function()
              local word = vim.b.telescope_grep_string_query
              sm.GrepString(true, word)
              vim.b.telescope_grep_string_query = word
            end,
          },
        },
      },

      buffers = {
        theme = "ivy",
        layout_config = {
          height = 0.9,
        },
        mappings = {
          i = {
            ["<c-d>"] = actions.delete_buffer,
          },
        },
      },

      diagnostics = {
        theme = "ivy",
        initial_mode = "normal",
      },

      git_commits = {
        theme = "ivy",
        layout_config = {
          height = 0.9,
        },
      },

      git_branches = {
        theme = "ivy",
        layout_config = {
          height = 0.9,
        },
      },
    }

    opts.extensions = {
      zoxide = {
        layout_config = {
          height = 0.9,
        },
        prompt_title = "[ Zoxide List ]",

        -- Zoxide list command with score
        list_command = "zoxide query -ls",
        mappings = {
          default = {
            keepinsert = true,
            action = function(selection)
              vim.cmd.cd(selection.path)
            end,
            after_action = function(selection)
              vim.notify("Directory changed to " .. selection.path)
              sm.FindFile(false, "cwd")
            end,
          },
          ["<C-s>"] = { action = z_utils.create_basic_command("split") },
          ["<C-v>"] = { action = z_utils.create_basic_command("vsplit") },
          ["<C-e>"] = { action = z_utils.create_basic_command("edit") },
          ["<C-f>"] = {
            keepinsert = true,
            action = function(selection)
              require("telescope.builtin").find_files({ cwd = selection.path })
            end,
          },
          ["<C-t>"] = {
            action = function(selection)
              vim.cmd.tcd(selection.path)
            end,
          },
        },
      },
    }

    telescope.setup(opts)
    telescope.load_extension("zoxide")
  end,
}
