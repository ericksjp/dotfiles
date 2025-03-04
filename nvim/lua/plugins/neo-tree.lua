local function getPath(state)
  local node = state.tree:get_node()
  local path = node.path
  if node.type == "file" then
    path = node:get_parent_id()
  end
  return path
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled=false,
  opts = {
    default_component_configs = {
      indent = {
        with_markers = false,
      },
    },
    window = {
      position = "left",
      mappings = {
        ["e"] = "navigate_up",
        ["/"] = "",
        ["D"] = "",
        ["#"] = "", -- fuzzy sorting using the fzy algorithm
        -- ["D"] = "fuzzy_sorter_directory",
        ["f"] = "",
        ["<c-x>"] = "",
        ["m"] = function(state)
          require("utils.pined").set_pined(getPath(state))
        end,

        ["p"] = "toggle_preview",
        [","] = function(state)
          local path = getPath(state)
          vim.cmd("cd " .. path)
          vim.notify("New CWD: " .. path, vim.log.levels.INFO)
        end,
        ["<tab>"] = function()
          require("utils.smart").Neotree(true)
        end,
        ["<leader><leader>"] = function(state)
          local path = getPath(state)
          require("telescope.builtin").find_files({
            no_ignore = false,
            hidden = true,
            cwd = path,
            prompt_title = "Find Files - " .. path,
          })
        end,
        ["<leader>fs"] = function(state)
          local path = getPath(state)
          require("telescope.builtin").live_grep({
            cwd = path,
            prompt_title = "Live Grep - " .. path,
          })
        end,
        ["o"] = function(state)
          local node = state.tree:get_node()
          local path = node:get_parent_id()
          require("oil").open_float(path, {}, function()
            pcall(function()
              vim.cmd("/" .. node.name)
            end)
          end)
        end,
        ["a"] = function(state)
          local node = state.tree:get_node()
          local path = getPath(state)
          require("oil").open_float(path, {}, function()
            pcall(function()
              vim.cmd("/" .. node.name)
              vim.api.nvim_feedkeys("O", "n", true)
            end)
          end)
        end,
      },
    },
  },
}
