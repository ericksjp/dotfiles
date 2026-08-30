local fzf = require("fzf-lua")
local actions = fzf.actions

local M = {}

local manual_selection = {}

local bwordactions = {"live_grep", "grep_cWORD", "grep_visual"}

M.track_selection = function(selected, _)
    manual_selection = selected or {}
end

M.fixed_qlist = function (selected, action_opts)
    local to_send = (#manual_selection > 0) and manual_selection or selected
    actions.file_sel_to_qf(to_send, action_opts)

    if (vim.tbl_contains(bwordactions, action_opts.__INFO.fnc)) then
        vim.b.word = action_opts.__call_opts.search or action_opts.__call_opts.query or ""
    end

    manual_selection = {}
end

return M
