---@class PickMe.Config
local M = {}

---@class PickMe.Config.config
---@field picker_provider string snacks (default) | telescope | fzf_lua | mini
---@field detect_provider boolean auto-detect the picker provider (default: true)
---@field add_default_keybindings boolean add default keybindings (default: false)
local config = {
    picker_provider = 'snacks',
    detect_provider = true,
    add_default_keybindings = false,
}

---@type PickMe.Config.config
M.config = config

local function is_module_available(module_name)
    local ok, _ = pcall(require, module_name)
    return ok
end

local function detect_provider()
    if is_module_available('telescope.builtin') then
        return 'telescope'
    elseif is_module_available('snacks.picker') then
        return 'snacks'
    elseif is_module_available('fzf-lua') then
        return 'fzf_lua'
    elseif is_module_available('mini.pick') then
        return 'mini'
    else
        vim.notify(
            'pickme.nvim: No picker provider found. Please install one of: telescope.nvim, snacks.nvim, fzf-lua, or mini.pick',
            vim.log.levels.WARN
        )
        return nil
    end
end

---@param args PickMe.Config.config
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})

    if M.config.detect_provider and not args.picker_provider then
        local detected_provider = detect_provider()
        if detected_provider then
            M.config.picker_provider = detected_provider
            vim.notify('pickme.nvim: Using ' .. detected_provider .. ' as picker provider', vim.log.levels.INFO)
        end
    end
end

return M
