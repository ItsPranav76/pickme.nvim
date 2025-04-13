local config = require('pickme.config')

---@class PickMe.Main
local M = {}

---@class PickMe.CommonOptions
---@field cwd? string -- Current working directory
---@field title? string -- Window title
---@field provider_override? string -- Picker provider to use

---@class PickMe.SelectFileOptions
---@field items string[] -- List of file paths to select from
---@field title string -- Window title
---@field provider_override? string -- Picker provider to use

---@class PickMe.CustomPickerOptions
---@field items table -- List of items to display
---@field title string -- Window title
---@field entry_maker fun(item:any):table -- Converts raw items to picker entries
---@field preview_generator fun(item:any):string -- Generates preview content as string
---@field preview_ft? string -- File type for preview content (defaults to 'markdown')
---@field selection_handler fun(bufnr:number|nil, selection:table) -- Handler for selection
---@field provider_override? string -- Picker provider to use

local picker_provider_map = {
    snacks = 'snacks.picker',
    telescope = 'telescope.builtin',
    fzf_lua = 'fzf-lua',
}

local function handle_opts(opts, provider)
    opts = opts or {}

    if opts.provider_override then
        opts.provider_override = nil
    end

    if provider == 'fzf_lua' and opts.title then
        local fzf_lua_prompt_suffix = ' '
        opts.prompt = opts.title .. fzf_lua_prompt_suffix
        opts.title = nil
    end

    if provider == 'telescope' and opts.title then
        opts.prompt_title = opts.title
        opts.title = nil
    end
    return opts
end

---@return table
M.get_commands = function()
    local commands = {
        'buffer_grep',
        'buffers',
        'colorschemes',
        'command_history',
        'commands',
        'diagnostics',
        'files',
        'git_branches',
        'git_commits',
        'git_files',
        'git_stash',
        'git_status',
        'grep_string',
        'help',
        'highlights',
        'jumplist',
        'keymaps',
        'live_grep',
        'lsp_definitions',
        'lsp_document_symbols',
        'lsp_implementations',
        'lsp_references',
        'lsp_type_definitions',
        'lsp_workspace_symbols',
        'man_pages',
        'marks',
        'oldfiles',
        'quickfix',
        'registers',
        'resume',
        'search_history',
        'spell_suggest',
        'tags',
        'treesitter',
    }

    for alias, _ in pairs(command_aliases) do
        table.insert(commands, alias)
    end

    return commands
end

---@param command string
---@param opts PickMe.CommonOptions
M.pick = function(command, opts)
    opts = opts or {}
    local provider = opts.provider_override or config.config.picker_provider
    local command_aliases = config.config.command_aliases
    if command_aliases[command] then
        command = command_aliases[command]
    end
    opts = handle_opts(opts, provider)

    opts = handle_opts(opts)
    vim.schedule(function()
        local cmd = require('pickme.' .. provider).command_map()[command]()
        require(picker_provider_map[provider])[cmd](opts)
    end)
end

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    opts = opts or {}
    local provider = opts.provider_override or config.config.picker_provider

    opts = handle_opts(opts, provider)
    vim.schedule(function()
        require('pickme.' .. provider).select_file(opts)
    end)
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    opts = opts or {}
    local provider = opts.provider_override or config.config.picker_provider

    opts = handle_opts(opts, provider)
    vim.schedule(function()
        require('pickme.' .. provider).custom_picker(opts)
    end)
end

return M
