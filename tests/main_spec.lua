local pickme = require('pickme')
local main = require('pickme.main')
local assert = require('luassert.assert')
local spy = require('luassert.spy')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

local mock = {}

mock.snacks_picker = {
    files = function() end,
    git_files = function() end,
    grep = function() end,
    grep_word = function() end,
    buffers = function() end,
    help = function() end,
    diagnostics = function() end,
    commands = function() end,
    git_branches = function() end,
    git_status = function() end,
    git_log = function() end,
    git_stash = function() end,
    lsp_references = function() end,
    lsp_symbols = function() end,
    lsp_workspace_symbols = function() end,
    lsp_type_definitions = function() end,
    lsp_definitions = function() end,
    lsp_implementations = function() end,
    keymaps = function() end,
    recent = function() end,
    registers = function() end,
    marks = function() end,
    highlights = function() end,
    colorschemes = function() end,
    command_history = function() end,
    search_history = function() end,
    spelling = function() end,
    resume = function() end,
    jumps = function() end,
    qflist = function() end,
    lines = function() end,
    treesitter = function() end,
    man = function() end,
    pick = function() end,
}

mock.telescope_builtin = {
    find_files = function() end,
    git_files = function() end,
    live_grep = function() end,
    grep_string = function() end,
    buffers = function() end,
    help_tags = function() end,
    diagnostics = function() end,
    commands = function() end,
    git_branches = function() end,
    git_status = function() end,
    git_commits = function() end,
    git_stash = function() end,
    lsp_references = function() end,
    lsp_document_symbols = function() end,
    lsp_workspace_symbols = function() end,
    lsp_type_definitions = function() end,
    lsp_definitions = function() end,
    lsp_implementations = function() end,
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
    jumplist = function() end,
    quickfix = function() end,
    tags = function() end,
    current_buffer_fuzzy_find = function() end,
    treesitter = function() end,
    man_pages = function() end,
}

mock.fzf_lua = {
    files = function() end,
    git_files = function() end,
    live_grep = function() end,
    grep_cword = function() end,
    buffers = function() end,
    help_tags = function() end,
    diagnostics = function() end,
    commands = function() end,
    git_branches = function() end,
    git_status = function() end,
    git_commits = function() end,
    git_stash = function() end,
    lsp_references = function() end,
    lsp_document_symbols = function() end,
    lsp_workspace_symbols = function() end,
    lsp_typedefs = function() end,
    lsp_definitions = function() end,
    lsp_implementations = function() end,
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
    jumps = function() end,
    quickfix = function() end,
    tags = function() end,
    lgrep_curbuf = function() end,
    treesitter = function() end,
    man_pages = function() end,
    fzf_exec = function() end,
}

mock.mini_pick = {
    builtin = {
        files = function() end,
        grep = function() end,
        buffers = function() end,
        help = function() end,
        cli = function() end,
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
        it('calls the correct snacks.picker function', function()
            pickme.setup({ picker_provider = 'snacks' })

            local files_spy = spy.on(mock.snacks_picker, 'files')

            main.pick('files', { title = 'Test Files' })

            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ title = 'Test Files' })
        end)

        it('calls the correct telescope function', function()
            pickme.setup({ picker_provider = 'telescope' })

            local files_spy = spy.on(mock.telescope_builtin, 'find_files')

            main.pick('files', { title = 'Test Files' })

            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ prompt_title = 'Test Files', title = 'Test Files' })
        end)

        it('calls the correct fzf_lua function', function()
            pickme.setup({ picker_provider = 'fzf_lua' })

            local files_spy = spy.on(mock.fzf_lua, 'files')

            main.pick('files', { title = 'Test Files' })

            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ prompt = 'Test Files ', title = 'Test Files' })
        end)

        it('calls the correct mini.pick function', function()
            pickme.setup({ picker_provider = 'mini' })

            local files_spy = spy.on(mock.mini_pick.builtin, 'files')

            main.pick('files', { title = 'Test Files' })

            assert.spy(files_spy).was_called(1)
            assert.spy(files_spy).was_called_with({ title = 'Test Files' })
        end)

        it('handles live_grep correctly across providers', function()
            local providers = {
                { name = 'snacks', main = mock.snacks_picker, func = 'grep' },
                { name = 'telescope', main = mock.telescope_builtin, func = 'live_grep' },
                { name = 'fzf_lua', main = mock.fzf_lua, func = 'live_grep' },
                { name = 'mini', main = mock.mini_pick.builtin, func = 'grep' },
            }

            for _, provider in ipairs(providers) do
                pickme.setup({ picker_provider = provider.name })

                local func_spy = spy.on(provider.main, provider.func)

                main.pick('live_grep', { title = 'Search Text' })

                assert.spy(func_spy).was_called(1)

                func_spy:clear()
            end
        end)

        it('handles more complex pickers like git_branches', function()
            local providers = {
                { name = 'snacks', main = mock.snacks_picker, func = 'git_branches' },
                { name = 'telescope', main = mock.telescope_builtin, func = 'git_branches' },
                { name = 'fzf_lua', main = mock.fzf_lua, func = 'git_branches' },
            }

            for _, provider in ipairs(providers) do
                pickme.setup({ picker_provider = provider.name })

                local branches_spy = spy.on(provider.main, provider.func)

                main.pick('git_branches', { title = 'Git Branches' })

                assert.spy(branches_spy).was_called(1)

                branches_spy:clear()
            end
        end)

        it('handles diagnostic picker correctly', function()
            local providers = {
                { name = 'snacks', main = mock.snacks_picker, func = 'diagnostics' },
                { name = 'telescope', main = mock.telescope_builtin, func = 'diagnostics' },
                { name = 'fzf_lua', main = mock.fzf_lua, func = 'diagnostics' },
            }

            for _, provider in ipairs(providers) do
                pickme.setup({ picker_provider = provider.name })

                local diag_spy = spy.on(provider.main, provider.func)

                main.pick('diagnostics', { title = 'Diagnostics' })

                assert.spy(diag_spy).was_called(1)

                diag_spy:clear()
            end
        end)
    end)
end)
