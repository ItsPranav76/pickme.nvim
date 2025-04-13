---@class PickMe.Config
local M = {}

---@class PickMe.Config.config
---@field picker_provider string snacks (default) | telescope | fzf_lua
---@field detect_provider boolean auto-detect the picker provider (default: true)
---@field add_default_keybindings boolean add default keybindings (default: true)
---@field command_aliases table<string, string> a map of command aliases to their actual commands
local config = {
    picker_provider = 'snacks',
    detect_provider = true,
    add_default_keybindings = true,
    command_aliases = {
        grep = 'live_grep',
    },
}

---@type PickMe.Config.config
M.config = config

local provider_modules = {
    snacks = 'snacks.picker',
    telescope = 'telescope.builtin',
    fzf_lua = 'fzf-lua',
}

local provider_priority = { 'snacks', 'telescope', 'fzf_lua' }

local function is_available(provider)
    local module = provider_modules[provider]
    if not module then
        return false
    end

    local ok = pcall(require, module)
    return ok
end

local function find_available_provider()
    for _, provider in ipairs(provider_priority) do
        if is_available(provider) then
            return provider
        end
    end
    return nil
end

---@param args PickMe.Config.config
M.setup = function(args)
    M.config = vim.tbl_deep_extend('force', M.config, args or {})

    local selected_provider = M.config.picker_provider

    if (M.config.detect_provider and not args or not args.picker_provider) or not is_available(selected_provider) then
        local available = find_available_provider()

        if not available then
            vim.notify(
                'pickme.nvim: No picker provider found. Please install one of: telescope.nvim, snacks.nvim, or fzf-lua',
                vim.log.levels.WARN
            )
            return
        end

        if selected_provider ~= available then
            if not is_available(selected_provider) and selected_provider ~= 'snacks' then
                vim.notify(
                    string.format(
                        'pickme.nvim: Selected provider "%s" not found. Using "%s" instead',
                        selected_provider,
                        available
                    ),
                    vim.log.levels.WARN
                )
            end

            M.config.picker_provider = available
        end
    end
end

return M
