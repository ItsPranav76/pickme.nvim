local assert = require('luassert.assert')
local spy = require('luassert.spy')
local stub = require('luassert.stub')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

local telescope = require('pickme.telescope')

describe('pickme.telescope', function()
    local orig_require
    local telescope_stubs = {}
    local finder_args = {}
    local options_received = {}
    local preview_called = false
    local mock_finder
    local replacement_fn

    before_each(function()
        finder_args = {}
        options_received = {}
        preview_called = false
        replacement_fn = nil

        mock_finder = { find = stub.new() }

        telescope_stubs = {}

        telescope_stubs.pickers = {
            new = spy.new(function(_, opts)
                options_received = opts
                return mock_finder
            end),
        }

        telescope_stubs.finders = {
            new_table = spy.new(function(opts)
                finder_args = opts
                return 'mock_finder_obj'
            end),
        }

        telescope_stubs.sorters = {
            get_fzy_sorter = stub.new().returns('mock_sorter'),
            get_generic_fuzzy_sorter = stub.new().returns('mock_fuzzy_sorter'),
        }

        telescope_stubs.previewers = {
            vim_buffer_cat = {
                new = stub.new().returns('mock_cat_previewer'),
            },
            new_buffer_previewer = function(opts)
                preview_called = true
                if opts and opts.define_preview then
                    telescope_stubs.previewers.define_preview = opts.define_preview
                end
                return 'mock_buffer_previewer'
            end,
        }

        telescope_stubs.make_entry = {
            gen_from_file = stub.new().returns('mock_entry_maker'),
        }

        telescope_stubs.actions_state = {
            get_selected_entry = stub.new().returns({ value = 'mock_selected_entry' }),
        }

        local select_default = {}
        select_default.replace = function(_, fn)
            replacement_fn = fn
            return fn
        end

        setmetatable(select_default, {
            __index = function(_, key)
                if key == 'replace' then
                    return function(fn)
                        replacement_fn = fn
                        return fn
                    end
                end
            end,
        })

        telescope_stubs.actions = {
            close = stub.new(),
            select_default = select_default,
        }

        orig_require = _G.require
        _G.require = function(module)
            if module == 'telescope.pickers' then
                return telescope_stubs.pickers
            elseif module == 'telescope.finders' then
                return telescope_stubs.finders
            elseif module == 'telescope.sorters' then
                return telescope_stubs.sorters
            elseif module == 'telescope.previewers' then
                return telescope_stubs.previewers
            elseif module == 'telescope.make_entry' then
                return telescope_stubs.make_entry
            elseif module == 'telescope.actions' then
                return telescope_stubs.actions
            elseif module == 'telescope.actions.state' then
                return telescope_stubs.actions_state
            end
            return orig_require(module)
        end

        package.loaded['pickme.telescope'] = nil

        _G.vim = _G.vim or {}
        _G.vim.bo = {}
        _G.vim.api = _G.vim.api or {}
        _G.vim.api.nvim_buf_set_lines = function() end
        _G.vim.split = function(str)
            return { str }
        end
    end)

    after_each(function()
        _G.require = orig_require
    end)

    describe('select_file', function()
        it('creates picker with correct options', function()
            local test_files = { 'file1.txt', 'file2.lua', 'file3.md' }
            local test_title = 'Select Files'

            telescope.select_file({
                items = test_files,
                prompt_title = test_title,
            })

            assert.spy(telescope_stubs.pickers.new).was_called(1)
            assert.spy(telescope_stubs.finders.new_table).was_called(1)

            assert.same(test_files, finder_args.results)
            assert.equals('mock_entry_maker', finder_args.entry_maker)

            assert.stub(mock_finder.find).was_called(1)
        end)
    end)

    describe('custom_picker', function()
        it('creates picker with custom options', function()
            local test_items = {
                { id = 1, name = 'Item 1' },
                { id = 2, name = 'Item 2' },
            }
            local entry_maker = function(item)
                return { display = item.name, value = item.id }
            end
            local preview_generator = function(item)
                return 'Preview for ' .. item
            end
            local selection_handler = function() end

            telescope.custom_picker({
                items = test_items,
                title = 'Custom Picker',
                entry_maker = entry_maker,
                preview_generator = preview_generator,
                preview_ft = 'markdown',
                selection_handler = selection_handler,
            })

            assert.spy(telescope_stubs.pickers.new).was_called(1)
            assert.spy(telescope_stubs.finders.new_table).was_called(1)

            assert.same(test_items, finder_args.results)
            assert.equals(entry_maker, finder_args.entry_maker)

            assert.is_true(preview_called)
            assert.equals('mock_buffer_previewer', options_received.previewer)
            assert.stub(mock_finder.find).was_called(1)
        end)

        it('sets up selection handler that calls close and gets selected entry', function()
            local selection_handler_spy = spy.new(function(bufnr, selection) end)
            local prompt_bufnr = 123

            telescope.custom_picker({
                items = { 'item1', 'item2' },
                title = 'Test Selection',
                entry_maker = function(item)
                    return { display = item, value = item }
                end,
                preview_generator = function(item)
                    return 'Preview for ' .. item
                end,
                selection_handler = selection_handler_spy,
            })

            assert.is_function(options_received.attach_mappings)
            options_received.attach_mappings(prompt_bufnr, {})
            assert.is_function(replacement_fn)

            replacement_fn()

            assert.stub(telescope_stubs.actions_state.get_selected_entry).was_called(1)
            assert.stub(telescope_stubs.actions.close).was_called(1)
            assert.stub(telescope_stubs.actions.close).was_called_with(prompt_bufnr)
            assert.spy(selection_handler_spy).was_called(1)
            assert.spy(selection_handler_spy).was_called_with(prompt_bufnr, { value = 'mock_selected_entry' })
        end)
    end)
end)
