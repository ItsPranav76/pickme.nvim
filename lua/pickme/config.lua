---@class PickMe.Config
local M = {}

---@class PickMe.Config.config
---@field picker_provider string snacks | telescope | fzf_lua | mini
local config = {
    picker_provider = 'snacks',
}

---@type PickMe.Config.config
M.config = config

---@param args PickMe.Config.config
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})
end

return M
