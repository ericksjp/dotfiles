local pickers = require("telescope.pickers")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local actions_state = require("telescope.actions.state")
local finders = require("telescope.finders")

-- logging
local log = require("plenary.log"):new()
log.level = "debug"

local M = {}
local list = {}
local current = 1

-- verifica se o path já está na lista
local function isInList(path)
  for _, v in ipairs(list) do
    if v.path == path then
      return true
    end
  end

  return false
end

-- move o item para cima recebendo como parametro o index desse item
local function moveUp(index)
  if index == 1 then
    return false
  end
  local placeholder = list[index - 1]
  list[index - 1] = list[index]
  list[index] = placeholder

  list[index].pos = index
  list[index - 1].pos = index - 1

  return true
end

-- move o item para baixo recebendo como parametro o index desse item
local function moveDown(pos)
  if pos == #list then
    return false
  end
  local placeholder = list[pos + 1]
  list[pos + 1] = list[pos]
  list[pos] = placeholder

  list[pos].pos = pos
  list[pos + 1].pos = pos + 1

  return true
end

local function newFinder()
  return finders.new_table({
    results = list,
    entry_maker = function(entry)
      return {
        value = entry,
        display = entry.pos .. ". " .. (entry.rPath or entry.path),
        ordinal = entry.path,
      }
    end,
  })
end

local function getRpath(path)
  if path:find(vim.fn.getcwd()) then
    return path:gsub(vim.fn.getcwd() .. "/", "")
  end
  return nil
end

vim.api.nvim_create_autocmd("DirChanged", {
  pattern = "*",
  callback = function()
    for _, v in pairs(list) do
      v.rPath = getRpath(v.path)
    end
  end,
})

M.add = function()
  local item = {}
  item.path = vim.api.nvim_buf_get_name(0)
  if isInList(item.path) then
    return
  end
  item.rPath = getRpath(item.path)
  item.pos = #list + 1

  table.insert(list, item)
end

M.delete = function(pos)
  table.remove(list, pos)

  for i = pos, #list do
    list[i].pos = i
  end
end

M.select = function(num)
  if num >= 1 and num <= #list then
    vim.cmd("e " .. list[num].path)
    current = num
  end
end

M.next = function()
  current = current + 1
  if current > #list then
    current = 1
  end
  M.select(current)
end

M.previous = function()
  current = current - 1
  if current < 1 then
    current = #list
  end
  M.select(current)
end

M.showList = function()
  local refresh_picker = function(picker, pos)
    picker:refresh(newFinder(), { reset_prompt = false })
    vim.defer_fn(function()
      picker:set_selection(pos)
    end, 5)
  end

  pickers
    .new({
      layout_strategy = "vertical",
      layout_config = {
        vertical = { width = 0.6, height = 0.6 },
        prompt_position = "top",
      },
    }, {
      finder = newFinder(),
      sorter = config.generic_sorter({}),

      attach_mappings = function(prompt_bufnr, map)
        local picker = actions_state.get_current_picker(prompt_bufnr)

        actions.select_default:replace(function()
          local selection = actions_state.get_selected_entry()
          actions.close(prompt_bufnr)
          vim.cmd("e " .. selection.value.path)
        end)

        local move_up = function()
          local selection = actions_state.get_selected_entry()
          if selection then
            local pos = selection.value.pos
            if moveUp(pos) then
              refresh_picker(picker, pos - 2)
            end
          end
        end

        local move_down = function()
          local selection = actions_state.get_selected_entry()
          if selection then
            local pos = selection.value.pos
            if moveDown(pos) then
              refresh_picker(picker, pos)
            end
          end
        end

        local delete_item = function()
          picker:delete_selection(function(selection)
            M.delete(selection.value.pos)
            return true
          end)
        end

        map("i", "<C-k>", move_up)
        map("i", "<C-j>", move_down)
        map("i", "<C-d>", delete_item)

        return true
      end,
    })
    :find()
end

return M
