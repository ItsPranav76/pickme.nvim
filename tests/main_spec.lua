local assert = require('luassert.assert')
local spy = require('luassert.spy')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

local pickme = require('pickme')
local main = require('pickme.main')
local config = require('pickme.config')

local command_mappings = {
    snacks = require('pickme.snacks').command_map(),
    telescope = require('pickme.telescope').command_map(),
    fzf_lua = require('pickme.fzf_lua').command_map(),
}

local mock = {}

local mock_modules = {
    { name = 'snacks', module = 'snacks_picker' },
    { name = 'telescope', module = 'telescope_builtin' },
    { name = 'fzf_lua', module = 'fzf_lua' },
}

for _, provider in ipairs(mock_modules) do
    mock[provider.module] = {}
    for _, func_name in pairs(command_mappings[provider.name]) do
        mock[provider.module][func_name] = function() end
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
        it('calls the correct provider function for commands with options', function()
            local cmd = 'files'
            local title = 'Test Files'
            local suffix = ' '
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
                    opts_check = { prompt_title = title },
                },
                {
                    provider = 'fzf_lua',
                    cmd = cmd,
                    mock_module = mock.fzf_lua,
                    func = command_mappings['fzf_lua'][cmd],
                    opts_check = { prompt = title .. suffix },
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
            }

            local all_commands = main.get_commands()
            local aliases = config.config.command_aliases

            for _, provider in ipairs(providers) do
                pickme.setup({ picker_provider = provider.name })
                local cmd_map_size = 0
                local alias_size = 0
                local function_spies = {}
                for _, func_name in pairs(provider.cmd_map) do
                    if provider.module[func_name] and not function_spies[func_name] then
                        function_spies[func_name] = spy.on(provider.module, func_name)
                        cmd_map_size = cmd_map_size + 1
                    end
                end

                local supported_count = 0
                for _, command in ipairs(all_commands) do
                    local cmd_to_check = command
                    local func_name = provider.cmd_map[cmd_to_check]

                    if not func_name and aliases and aliases[command] then
                        cmd_to_check = aliases[command]
                        func_name = provider.cmd_map[cmd_to_check]
                        alias_size = alias_size + 1
                    end

                    if func_name then
                        supported_count = supported_count + 1
                        main.pick(command, { title = 'Test ' .. command })
                    end
                end

                local called_count = 0
                for _, spy_obj in pairs(function_spies) do
                    if spy_obj.calls and #spy_obj.calls > 0 then
                        called_count = called_count + 1
                    end
                    spy_obj:revert()
                end

                assert.are.equal(
                    supported_count,
                    cmd_map_size + alias_size,
                    'Provider ' .. provider.name .. ' should support all commands in mock'
                )

                assert.are.equal(
                    called_count,
                    cmd_map_size,
                    'Provider ' .. provider.name .. ' should have all functions called'
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
            assert.truthy(vim.tbl_contains(commands, 'git_log'))

            local expected_count = 35 -- 34 base commands + 1 alias from config
            assert.are.equal(expected_count, #commands)
        end)
    end)
end)
