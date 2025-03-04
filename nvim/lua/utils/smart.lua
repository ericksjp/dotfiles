local get_pined = require("utils.pined").get_pined
local M = {}

local featureUsageCount = {
  oil = 0,
  liveGrep = 0,
  fileFinder = 0,
  neo_tree = 0,
}

local dirMap = {
  {
    name = "Root Directory",
    path = LazyVim.root,
  },
  {
    name = "Current Working Directory",
    path = vim.fn.getcwd,
  },
  {
    name = "Current Buffer Directory",
    path = function()
      return vim.fn.expand("%:p:h")
    end,
  },
  {
    name = "Pine Directory",
    path = get_pined,
  },
}

-- local lastBufferBeforeOil = nil
-- local lastRootBeforeOil = LazyVim.root()
-- local bufferBeforeTsPrompt = nil

--------------------------------------------------------------------------------------------

-- local notGood = { "copilot-chat", "telescope" }
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = "*",
--   callback = function()
--     if vim.bo.filetype ~= "oil" and vim.tbl_contains(notGood, vim.fn.expand("%")) == false then
--       lastRootBeforeOil = LazyVim.root()
--       lastBufferBeforeOil = vim.fn.expand("%:p:h")
--     end
--   end,
-- })

--------------------------------------------------------------------------------------------

local function increase(num)
  local endNum = get_pined() and 4 or 3
  return (num + 1) % endNum
end

local function LiveGrep(dir, name, word)
  if word then
    require("telescope.builtin").grep_string({
      cwd = dir,
      search = word,
      prompt_title = "Grep String (" .. word .. ")(" .. name .. ")",
    })
    vim.b.telescope_grep_string_query = word
  else
    require("telescope.builtin").live_grep({
      cwd = dir,
      prompt_title = "Live Grep (" .. name .. ")",
    })
  end
end

local function GrepFiles(dir, name)
  require("telescope.builtin").find_files({
    no_ignore = false,
    hidden = true,
    cwd = dir,
    prompt_title = "Find Files (" .. name .. ")",
  })
end

--------------------------------------------------------------------------------------------

M.CurrentDir = function()
  local ft = vim.bo.filetype
  if ft == "neo-tree" then
    return dirMap[featureUsageCount["neo_tree"] + 1].name
  elseif ft == "oil" then
    local current = require("oil").get_current_dir()
    return dirMap[featureUsageCount["oil"] + 1].name
  end
  return ""
end

-- M.Neotree = function(next)
--   if next == true then
--     featureUsageCount.neo_tree = increase(featureUsageCount.neo_tree)
--     vim.cmd("Neotree dir=" .. dirMap[featureUsageCount.neo_tree + 1].path())
--   else
--     vim.cmd("Neotree toggle=true dir=" .. dirMap[featureUsageCount.neo_tree + 1].path())
--   end
-- end

M.MiniFiles = function(next)
  if next == true then
    featureUsageCount.oil = increase(featureUsageCount.oil)
    require("mini.files").close()
  end
  require("mini.files").open(dirMap[featureUsageCount.oil + 1].path())
end

M.GrepString = function(next, word)
  if next == true then
    featureUsageCount.liveGrep = increase(featureUsageCount.liveGrep)
  else
    bufferBeforeTsPrompt = require("mini.files").get_latest_path() or vim.fn.expand("%:p:h")
  end
  local pos = featureUsageCount.liveGrep + 1
  LiveGrep(dirMap[pos].path(), dirMap[pos].name, word)
end

M.FindFile = function(next, dir)
  -- if dir then
  --   FileFinder = dirMap[dir]
  --   featureUsageCount.oil = FileFinder
  --   GrepFiles(getPath(FileFinder), dirMap["fileFinder"].name)
  --   return
  -- end

  if next == true then
    featureUsageCount.fileFinder = increase(featureUsageCount.fileFinder)
  else
    bufferBeforeTsPrompt = require("mini.files").get_latest_path() or vim.fn.expand("%:p:h")
  end
  local pos = featureUsageCount.fileFinder + 1
  GrepFiles(dirMap[pos].path(), dirMap[pos].name)
end

return M
