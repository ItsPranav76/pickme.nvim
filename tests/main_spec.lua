local pickme = require('pickme')
local main = require('pickme.main')
local assert = require('luassert.assert')
local spy = require('luassert.spy')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

-- Mock dependencies
local mock = {}

-- Setup mock for snacks.picker
mock.snacks_picker = {
    files = function() end,
    git_files = function() end,
    grep = function() end,
    buffers = function() end,
    help = function() end,
    diagnostics = function() end,
    commands = function() end,
    git_branches = function() end,
    git_status = function() end,
    git_log = function() end,
    lsp_references = function() end,
    lsp_document_symbols = function() end,
    lsp_workspace_symbols = function() end,
    keymaps = function() end,
    oldfiles = function() end,
    registers = function() end,
    marks = function() end,
    highlights = function() end,
    colorschemes = function() end,
    command_history = function() end,
    search_history = function() end,
    resume = function() end,
    pick = function() end,
}

-- Setup mock for telescope.builtin
mock.telescope_builtin = {
    find_files = function() end,
    git_files = function() end,
    live_grep = function() end,
    buffers = function() end,
    help_tags = function() end,
    diagnostics = function() end,
    commands = function() end,
    git_branches = function() end,
    git_status = function() end,
    git_commits = function() end,
    lsp_references = function() end,
    lsp_document_symbols = function() end,
    lsp_workspace_symbols = function() end,
    keymaps = function() end,
    oldfiles = function() end,
    registers = function() end,
    marks = function() end,
    highlights = function() end,
    colorscheme = function() end,
    command_history = function() end,
    search_history = function() end,
    spell_suggest = function() end,
    resume = function() end,
}

-- Setup mock for fzf-lua
mock.fzf_lua = {
    files = function() end,
    git_files = function() end,
    live_grep = function() end,
    buffers = function() end,
    help_tags = function() end,
    diagnostics = function() end,
    commands = function() end,
    git_branches = function() end,
    git_status = function() end,
    git_commits = function() end,
    lsp_references = function() end,
    lsp_document_symbols = function() end,
    lsp_workspace_symbols = function() end,
    keymaps = function() end,
    oldfiles = function() end,
    registers = function() end,
    marks = function() end,
    highlights = function() end,
    colorschemes = function() end,
    command_history = function() end,
    search_history = function() end,
    spell_suggest = function() end,
    resume = function() end,
    fzf_exec = function() end,
}

-- Setup mock for mini.pick
mock.mini_pick = {
    builtin = {
        files = function() end,
        grep = function() end,
        buffers = function() end,
        help = function() end,
        diagnostic = function() end,
        cli = function() end,
        git_branches = function() end,
        git_status = function() end,
        git_commits = function() end,
        lsp = function() end,
        oldfiles = function() end,
        registers = function() end,
        marks = function() end,
        pick = function() end,
    },
}

describe('pickme.main', function()
    local orig_require = _G.require
    local orig_schedule = vim.schedule

    -- Setup the mocks before each test
    before_each(function()
        -- Mock require to return our mocks
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

        -- Mock vim.schedule to run the function immediately
        vim.schedule = function(fn)
            fn()
        end

        -- Reset pickme default config
        pickme.setup({})
    end)

    -- Restore original functions after each test
    after_each(function()
        _G.require = orig_require
        vim.schedule = orig_schedule
    end)

    describe('pick', function()
        it('calls the correct snacks.picker function', function()
            -- Set picker provider to snacks
            pickme.setup({ picker_provider = 'snacks' })

            -- Spy on the mock
            local files_spy = spy.on(mock.snacks_picker, 'files')

            -- Call the module function
            main.pick('files', { title = 'Test Files' })

            -- Assert the spy was called with correct options
            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ title = 'Test Files' })
        end)

        it('calls the correct telescope function', function()
            -- Set picker provider to telescope
            pickme.setup({ picker_provider = 'telescope' })

            -- Spy on the mock
            local files_spy = spy.on(mock.telescope_builtin, 'find_files')

            -- Call the module function
            main.pick('files', { title = 'Test Files' })

            -- Assert the spy was called with correct options
            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ prompt_title = 'Test Files', title = 'Test Files' })
        end)

        it('calls the correct fzf_lua function', function()
            -- Set picker provider to fzf_lua
            pickme.setup({ picker_provider = 'fzf_lua' })

            -- Spy on the mock
            local files_spy = spy.on(mock.fzf_lua, 'files')

            -- Call the module function
            main.pick('files', { title = 'Test Files' })

            -- Assert the spy was called with correct options
            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ prompt = 'Test Files ', title = 'Test Files' })
        end)

        it('calls the correct mini.pick function', function()
            -- Set picker provider to mini
            pickme.setup({ picker_provider = 'mini' })

            -- Spy on the mock
            local files_spy = spy.on(mock.mini_pick.builtin, 'files')

            -- Call the module function
            main.pick('files', { title = 'Test Files' })

            -- Assert the spy was called with correct options
            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ title = 'Test Files' })
        end)

        it('handles live_grep correctly across providers', function()
            -- Test with each provider
            local providers = {
                { name = 'snacks', main = mock.snacks_picker, func = 'grep' },
                { name = 'telescope', main = mock.telescope_builtin, func = 'live_grep' },
                { name = 'fzf_lua', main = mock.fzf_lua, func = 'live_grep' },
                { name = 'mini', main = mock.mini_pick.builtin, func = 'grep' },
            }

            for _, provider in ipairs(providers) do
                -- Set the provider
                pickme.setup({ picker_provider = provider.name })

                -- Spy on the mock
                local func_spy = spy.on(provider.main, provider.func)

                -- Call the module function
                main.pick('live_grep', { title = 'Search Text' })

                -- Assert the spy was called
                assert.spy(func_spy).was_called(1)

                -- Clean up the spy
                func_spy:clear()
            end
        end)

        it('handles more complex pickers like git_branches', function()
            -- Test with each provider
            local providers = {
                { name = 'snacks', main = mock.snacks_picker, func = 'git_branches' },
                { name = 'telescope', main = mock.telescope_builtin, func = 'git_branches' },
                { name = 'fzf_lua', main = mock.fzf_lua, func = 'git_branches' },
                { name = 'mini', main = mock.mini_pick.builtin, func = 'git_branches' },
            }

            for _, provider in ipairs(providers) do
                -- Set the provider
                pickme.setup({ picker_provider = provider.name })

                -- Spy on the mock
                local branches_spy = spy.on(provider.main, provider.func)

                -- Call the module function
                main.pick('git_branches', { title = 'Git Branches' })

                -- Assert the spy was called
                assert.spy(branches_spy).was_called(1)

                -- Clean up the spy
                branches_spy:clear()
            end
        end)

        it('handles diagnostic picker correctly', function()
            -- Test with each provider
            local providers = {
                { name = 'snacks', main = mock.snacks_picker, func = 'diagnostics' },
                { name = 'telescope', main = mock.telescope_builtin, func = 'diagnostics' },
                { name = 'fzf_lua', main = mock.fzf_lua, func = 'diagnostics' },
                { name = 'mini', main = mock.mini_pick.builtin, func = 'diagnostic' },
            }

            for _, provider in ipairs(providers) do
                -- Set the provider
                pickme.setup({ picker_provider = provider.name })

                -- Spy on the mock
                local diag_spy = spy.on(provider.main, provider.func)

                -- Call the module function
                main.pick('diagnostics', { title = 'Diagnostics' })

                -- Assert the spy was called
                assert.spy(diag_spy).was_called(1)

                -- Clean up the spy
                diag_spy:clear()
            end
        end)
    end)
end)
