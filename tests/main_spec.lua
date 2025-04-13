local pickme = require('pickme')
local main = require('pickme.main')
local assert = require('luassert.assert')
local spy = require('luassert.spy')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

local command_mappings = {
    snacks = {
        files = 'files',
        git_files = 'git_files',
        live_grep = 'grep',
        grep_string = 'grep_word',
        buffers = 'buffers',
        help = 'help',
        diagnostics = 'diagnostics',
        commands = 'commands',
        git_branches = 'git_branches',
        git_status = 'git_status',
        git_commits = 'git_log',
        git_stash = 'git_stash',
        lsp_references = 'lsp_references',
        lsp_document_symbols = 'lsp_symbols',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        lsp_type_definitions = 'lsp_type_definitions',
        lsp_definitions = 'lsp_definitions',
        lsp_implementations = 'lsp_implementations',
        keymaps = 'keymaps',
        oldfiles = 'recent',
        registers = 'registers',
        marks = 'marks',
        highlights = 'highlights',
        colorschemes = 'colorschemes',
        command_history = 'command_history',
        search_history = 'search_history',
        spell_suggest = 'spelling',
        resume = 'resume',
        jumplist = 'jumps',
        quickfix = 'qflist',
        buffer_grep = 'lines',
        treesitter = 'treesitter',
        man_pages = 'man',
    },
    telescope = {
        files = 'find_files',
        git_files = 'git_files',
        live_grep = 'live_grep',
        grep_string = 'grep_string',
        buffers = 'buffers',
        help = 'help_tags',
        diagnostics = 'diagnostics',
        commands = 'commands',
        git_branches = 'git_branches',
        git_status = 'git_status',
        git_commits = 'git_commits',
        git_stash = 'git_stash',
        lsp_references = 'lsp_references',
        lsp_document_symbols = 'lsp_document_symbols',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        lsp_type_definitions = 'lsp_type_definitions',
        lsp_definitions = 'lsp_definitions',
        lsp_implementations = 'lsp_implementations',
        keymaps = 'keymaps',
        oldfiles = 'oldfiles',
        registers = 'registers',
        marks = 'marks',
        highlights = 'highlights',
        colorschemes = 'colorscheme',
        command_history = 'command_history',
        search_history = 'search_history',
        spell_suggest = 'spell_suggest',
        resume = 'resume',
        jumplist = 'jumplist',
        quickfix = 'quickfix',
        tags = 'tags',
        buffer_grep = 'current_buffer_fuzzy_find',
        treesitter = 'treesitter',
        man_pages = 'man_pages',
    },
    fzf_lua = {
        files = 'files',
        git_files = 'git_files',
        live_grep = 'live_grep',
        grep_string = 'grep_cword',
        buffers = 'buffers',
        help = 'help_tags',
        diagnostics = 'diagnostics',
        commands = 'commands',
        git_branches = 'git_branches',
        git_status = 'git_status',
        git_commits = 'git_commits',
        git_stash = 'git_stash',
        lsp_references = 'lsp_references',
        lsp_document_symbols = 'lsp_document_symbols',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        lsp_type_definitions = 'lsp_typedefs',
        lsp_definitions = 'lsp_definitions',
        lsp_implementations = 'lsp_implementations',
        keymaps = 'keymaps',
        oldfiles = 'oldfiles',
        registers = 'registers',
        marks = 'marks',
        highlights = 'highlights',
        colorschemes = 'colorschemes',
        command_history = 'command_history',
        search_history = 'search_history',
        spell_suggest = 'spell_suggest',
        resume = 'resume',
        jumplist = 'jumps',
        quickfix = 'quickfix',
        tags = 'tags',
        buffer_grep = 'lgrep_curbuf',
        treesitter = 'treesitter',
        man_pages = 'man_pages',
    },
    mini = {
        files = 'files',
        git_files = 'files',
        live_grep = 'grep',
        grep_string = 'grep',
        buffers = 'buffers',
        help = 'help',
    },
}

local mock = {}

local mock_modules = {
    { name = 'snacks', module = 'snacks_picker', is_nested = false, extra = { pick = function() end } },
    { name = 'telescope', module = 'telescope_builtin', is_nested = false, extra = {} },
    { name = 'fzf_lua', module = 'fzf_lua', is_nested = false, extra = { fzf_exec = function() end } },
    { name = 'mini', module = 'mini_pick.builtin', is_nested = true, extra = {} },
}

for _, provider in ipairs(mock_modules) do
    if provider.is_nested then
        local parts = vim.split(provider.module, '.', { plain = true })
        mock[parts[1]] = { [parts[2]] = {} }
        for _, func_name in pairs(command_mappings[provider.name]) do
            mock[parts[1]][parts[2]][func_name] = function() end
        end
        -- Add any extra functions
        for func_name, func in pairs(provider.extra) do
            mock[parts[1]][parts[2]][func_name] = func
        end
    else
        mock[provider.module] = {}
        for _, func_name in pairs(command_mappings[provider.name]) do
            mock[provider.module][func_name] = function() end
        end
        -- Add any extra functions
        for func_name, func in pairs(provider.extra) do
            mock[provider.module][func_name] = func
        end
    end
end

describe('pickme.main', function()
    local orig_require = _G.require
    local orig_schedule = vim.schedule

    before_each(function()
        _G.require = function(module_name)
            if module_name == 'snacks.picker' then
                return mock.snacks_picker
            elseif module_name == 'telescope.builtin' then
                return mock.telescope_builtin
            elseif module_name == 'fzf-lua' then
                return mock.fzf_lua
            elseif module_name == 'mini.pick' then
                return mock.mini_pick
            else
                return orig_require(module_name)
            end
        end

        vim.schedule = function(fn)
            fn()
        end

        pickme.setup({})
    end)

    after_each(function()
        _G.require = orig_require
        vim.schedule = orig_schedule
    end)

    describe('pick', function()
        it('calls the correct provider function for basic commands', function()
            local cmd = 'files'
            local title = 'Test Files'
            local test_cases = {
                {
                    provider = 'snacks',
                    cmd = cmd,
                    mock_module = mock.snacks_picker,
                    func = command_mappings['snacks'][cmd],
                    opts_check = { title = title },
                },
                {
                    provider = 'telescope',
                    cmd = cmd,
                    mock_module = mock.telescope_builtin,
                    func = command_mappings['telescope'][cmd],
                    opts_check = { prompt_title = title, title = title },
                },
                {
                    provider = 'fzf_lua',
                    cmd = cmd,
                    mock_module = mock.fzf_lua,
                    func = command_mappings['fzf_lua'][cmd],
                    opts_check = { prompt = title .. ' ', title = title },
                },
                {
                    provider = 'mini',
                    cmd = cmd,
                    mock_module = mock.mini_pick.builtin,
                    func = command_mappings['mini'][cmd],
                    opts_check = { title = title },
                },
            }

            for _, case in ipairs(test_cases) do
                pickme.setup({ picker_provider = case.provider })
                local func_spy = spy.on(case.mock_module, case.func)

                main.pick(case.cmd, { title = 'Test Files' })

                assert.spy(func_spy).was_called(1)
                assert.spy(func_spy).was_called_with(case.opts_check)

                func_spy:clear()
            end
        end)

        it('calls the correct provider function for all supported commands', function()
            local providers = {
                { name = 'snacks', module = mock.snacks_picker, cmd_map = command_mappings.snacks },
                { name = 'telescope', module = mock.telescope_builtin, cmd_map = command_mappings.telescope },
                { name = 'fzf_lua', module = mock.fzf_lua, cmd_map = command_mappings.fzf_lua },
                { name = 'mini', module = mock.mini_pick.builtin, cmd_map = command_mappings.mini },
            }

            local all_commands = main.get_commands()

            -- Test each provider
            for _, provider in ipairs(providers) do
                pickme.setup({ picker_provider = provider.name })

                -- Create spies for all functions in this provider's module
                local function_spies = {}
                for _, func_name in pairs(provider.cmd_map) do
                    if provider.module[func_name] and not function_spies[func_name] then
                        function_spies[func_name] = spy.on(provider.module, func_name)
                    end
                end

                -- Call each command that's supported by this provider
                local supported_count = 0
                for _, command in ipairs(all_commands) do
                    -- Try both the command directly and any resolved alias
                    local cmd_to_check = command
                    local func_name = provider.cmd_map[cmd_to_check]

                    if not func_name and main._command_aliases and main._command_aliases[command] then
                        cmd_to_check = main._command_aliases[command]
                        func_name = provider.cmd_map[cmd_to_check]
                    end

                    if func_name then
                        supported_count = supported_count + 1
                        main.pick(command, { title = 'Test ' .. command })
                    end
                end

                -- Check that we had at least some supported commands
                assert.is_true(
                    supported_count > 0,
                    'Provider ' .. provider.name .. ' should support at least one command'
                )

                -- Verify that functions were called
                local called_count = 0
                for func_name, spy_obj in pairs(function_spies) do
                    if spy_obj.calls and #spy_obj.calls > 0 then
                        called_count = called_count + 1
                    end
                    spy_obj:revert() -- Clean up the spy
                end

                -- Make sure we had some function calls
                assert.is_true(
                    called_count > 0,
                    'Provider ' .. provider.name .. ' should have at least one function called'
                )
            end
        end)
    end)

    describe('get_commands', function()
        it('returns all available commands', function()
            local commands = main.get_commands()

            -- Check for some core commands
            assert.truthy(vim.tbl_contains(commands, 'files'))
            assert.truthy(vim.tbl_contains(commands, 'live_grep'))
            assert.truthy(vim.tbl_contains(commands, 'buffers'))
            assert.truthy(vim.tbl_contains(commands, 'git_branches'))
            assert.truthy(vim.tbl_contains(commands, 'diagnostics'))

            -- Check for aliases
            assert.truthy(vim.tbl_contains(commands, 'grep'))
            assert.truthy(vim.tbl_contains(commands, 'find_files'))
            assert.truthy(vim.tbl_contains(commands, 'help_tags'))

            local expected_count = 43 -- 34 base commands + 9 aliases from command_aliases table
            assert.are.equal(expected_count, #commands)
        end)
    end)
end)
