local uv = vim.uv

local M = {}

local opts = {
  filepath = vim.fn.stdpath("data") .. "/bgfile",
}

local fe

local function setOpts(o)
  opts = vim.tbl_extend("force", opts, o or {})
end

local function inform(msg, level)
  level = level or vim.log.levels.ERROR
  vim.notify(msg, level, { title = "bg-plugin" })
end

local function getFileDescriptor(filepath)
  local fd, err = uv.fs_open(filepath, "r", 436)
  if not fd then
    inform("Could not open file: " .. opts.filepath .. " " .. err)
    return -1
  end
  return fd
end

local function getFileSize(filepath)
  local stat, err = uv.fs_stat(filepath)
  if not stat then
    inform("Could not stat file: " .. opts.filepath .. " " .. err)
    return -1
  end
  return stat.size
end

local function getFileData(fd, size)
  local data, err = uv.fs_read(fd, size)
  if not data then
    inform("Could not read file: " .. opts.filepath .. " " .. err)
    return nil
  end
  return data
end

local function readFile()
  local fd = getFileDescriptor(opts.filepath)
  if fd < 0 then
    return nil
  end

  local size = getFileSize(opts.filepath)
  if size < 0 then
    uv.fs_close(fd)
    return nil
  end

  local data = getFileData(fd, size)
  if not data then
    uv.fs_close(fd)
    return nil
  end

  uv.fs_close(fd)
  return data
end

local function changeBgVal(val)
  local bgval = val == "1" and "light" or "dark"
  vim.cmd("set background=" .. bgval)
end

local function setBg()
  local val = readFile()
  if not val then
    return false
  end

  val = val:gsub("[\n\r]", "")
  if vim.tbl_contains({ "1", "0" }, val) then
    changeBgVal(val)
  else
    inform("Invalid Value: " .. val)
    return false
  end

  return true
end

local function watch()
  if fe then
    return false
  end

  fe = uv.new_fs_event()
  if not fe then
    inform("Could not initialize fs_event watcher: " .. opts.filepath)
    return false
  end

  fe:start(opts.filepath, {}, function(err, _, events)
    if err then
      inform("Error in fs_event watcher: " .. err)
      return
    elseif events.rename then
      inform("Erro in fs_event watcher: " .. events.rename)
      fe:stop()
      fe = nil
      return
    end
    vim.schedule(function()
      setBg()
    end)
  end)

  return true
end

M.setup = function(o)
  setOpts(o)
  watch()
end

return M
