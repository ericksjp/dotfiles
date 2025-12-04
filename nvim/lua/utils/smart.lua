local get_pined = require("utils.pined").get_pined
local M = {}

-- return a table with some data to be used
local function mountDirStruct()
  return {
    paths = {
      { name = "PD", path = get_pined },
      { name = "CWD", path = vim.fn.getcwd },
      {
        name = "CBD",
        path = function()
          return BufferBeforeTsPrompt or vim.fn.expand("%:p:h")
        end,
      },
      { name = "Root", path = LazyVim.root },
    },
    current = 1,

    next = function(self)
      self.current = math.max(1, (self.current + 1) % (#self.paths + 1))
    end,

    currentPath = function(self)
      local path = self.paths[self.current]
      if path.name == "PD" and path.path() == nil then
        self:next()
        path = self.paths[self.current]
      end

      return path
    end,
  }
end

local featureUsageCount = {
  mini_files = mountDirStruct(),
  oil = mountDirStruct(),
  liveGrep = mountDirStruct(),
  fileFinder = mountDirStruct(),
  neo_tree = mountDirStruct(),
}

BufferBeforeTsPrompt = vim.fn.getcwd()

--------------------------------------------------------------------------------------------

local function isOilOrMini()
  return vim.bo.filetype == "oil" or vim.bo.filetype == "minifiles"
end

local notGood = { "copilot-chat", "telescope" }
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if not isOilOrMini() and vim.tbl_contains(notGood, vim.fn.expand("%")) == false and vim.fn.expand("%") ~= "" then
      BufferBeforeTsPrompt = vim.fn.expand("%:p:h")
    end

    -- if vim.bo.filetype ~= "minifiles" and vim.tbl_contains(notGood, vim.fn.expand("%")) == false and vim.fn.expand("%") ~= "" then
    --   BufferBeforeTsPrompt = vim.fn.expand("%:p:h")
    -- end
  end,
})

--------------------------------------------------------------------------------------------

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

local function GrepFilesSnack(dir, name)
  Snacks.picker.files({
    dirs = { dir },
  })
end

--------------------------------------------------------------------------------------------

M.CurrentDir = function()
  local ft = vim.bo.filetype
  if ft == "neo-tree" then
    return featureUsageCount.neo_tree:currentPath()
  elseif ft == "oil" then
    return featureUsageCount.oil:currentPath()
  end
  return ""
end

M.Neotree = function(next)
  local toggle = "toggle"
  if next == true then
    featureUsageCount.neo_tree:next()
    toggle = ""
  end

  vim.cmd("Neotree " .. toggle .. " dir=" .. featureUsageCount.neo_tree:currentPath().path())
end

M.MiniFiles = function(next)
  if next == true then
    featureUsageCount.mini_files:next()
    require("mini.files").close()
  end

  require("mini.files").open(featureUsageCount.mini_files:currentPath().path())
end

M.bufferBeforeOil = nil

M.Oil = function(next)
  if next == true then
    featureUsageCount.oil:next()
  end

  local current = featureUsageCount.oil:currentPath()

  if current.name == "CBD" then
    M.bufferBeforeOil = vim.api.nvim_buf_get_name(0)
  end

  require("oil").open(current.path())
end

M.GrepString = function(next, word)
  if next == true then
    featureUsageCount.liveGrep:next()
  end
  local path = featureUsageCount.liveGrep:currentPath()
  LiveGrep(path.path(), path.name, word)
end

M.FindFile = function(next, _)
  -- if dir then
  --   FileFinder = dirMap[dir]
  --   featureUsageCount.oil = FileFinder
  --   GrepFiles(getPath(FileFinder), dirMap["fileFinder"].name)
  --   return
  -- end

  if next == true then
    featureUsageCount.fileFinder:next()
  end
  local path = featureUsageCount.fileFinder:currentPath()
  GrepFiles(path.path(), path.name)
end

return M
