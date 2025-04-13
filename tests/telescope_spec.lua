local assert = require('luassert.assert')
local spy = require('luassert.spy')
local stub = require('luassert.stub')
local match = require('luassert.match')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

describe('pickme.telescope', function()
    -- Store the original functions
    local telescope_provider
    local orig_require

    -- Create stub modules for telescope
    local telescope_stubs = {}

    -- Variables to capture function calls and arguments
    local finder_args = {}
    local options_received = {}
    local preview_called = false
    local mock_finder
    local replacement_fn

    before_each(function()
        -- Clear the captured arguments
        finder_args = {}
        options_received = {}
        preview_called = false
        replacement_fn = nil

        -- Setup the actual picker object that will be returned by telescope.pickers.new
        mock_finder = { find = stub.new() }

        -- Create fresh stubs for each test
        telescope_stubs = {}

        -- Mock pickers module
        telescope_stubs.pickers = {
            new = spy.new(function(_, opts)
                options_received = opts
                return mock_finder
            end),
        }

        -- Mock finders module
        telescope_stubs.finders = {
            new_table = spy.new(function(opts)
                -- Store the arguments to inspect later
                finder_args = opts
                return 'mock_finder_obj'
            end),
        }

        -- Mock sorters module
        telescope_stubs.sorters = {
            get_fzy_sorter = stub.new().returns('mock_sorter'),
            get_generic_fuzzy_sorter = stub.new().returns('mock_fuzzy_sorter'),
        }

        -- Mock previewers module
        telescope_stubs.previewers = {
            vim_buffer_cat = {
                new = stub.new().returns('mock_cat_previewer'),
            },
            new_buffer_previewer = function(opts)
                preview_called = true
                if opts and opts.define_preview then
                    -- Store the preview function for testing if needed
                    telescope_stubs.previewers.define_preview = opts.define_preview
                end
                return 'mock_buffer_previewer'
            end,
        }

        -- Mock make_entry module
        telescope_stubs.make_entry = {
            gen_from_file = stub.new().returns('mock_entry_maker'),
        }

        -- Mock actions and actions_state modules with specific behavior for select_default.replace
        telescope_stubs.actions_state = {
            get_selected_entry = stub.new().returns({ value = 'mock_selected_entry' }),
        }

        -- Create a proper table with metatable for select_default
        local select_default = {}
        select_default.replace = function(_, fn)
            replacement_fn = fn
            return fn
        end
        -- Set metatable to handle the colon syntax properly
        setmetatable(select_default, {
            __index = function(_, key)
                if key == 'replace' then
                    return function(fn)
                        replacement_fn = fn
                        return fn
                    end
                end
            end
        })

        -- Mock actions module with proper select_default object
        telescope_stubs.actions = {
            close = stub.new(),
            select_default = select_default,
        }

        -- Override require to return our stubs
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

        -- Create a fresh instance for each test to avoid cross-test pollution
        package.loaded['pickme.telescope'] = nil
        telescope_provider = require('pickme.telescope')

        -- Mock vim API functions
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

            telescope_provider.select_file({
                items = test_files,
                prompt_title = test_title,
            })

            -- Verify telescope.pickers.new was called
            assert.spy(telescope_stubs.pickers.new).was_called(1)

            -- Verify telescope.finders.new_table was called with the correct options
            assert.spy(telescope_stubs.finders.new_table).was_called(1)

            -- Use match.same for deep table comparison
            assert.same(test_files, finder_args.results)
            assert.equals('mock_entry_maker', finder_args.entry_maker)

            -- Verify find was called on the picker returned by telescope.pickers.new
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

            telescope_provider.custom_picker({
                items = test_items,
                title = 'Custom Picker',
                entry_maker = entry_maker,
                preview_generator = preview_generator,
                preview_ft = 'markdown',
                selection_handler = selection_handler,
            })

            -- Verify telescope.pickers.new was called
            assert.spy(telescope_stubs.pickers.new).was_called(1)

            -- Verify telescope.finders.new_table was called with correct options
            assert.spy(telescope_stubs.finders.new_table).was_called(1)

            -- Use deep comparison for tables
            assert.same(test_items, finder_args.results)
            assert.equals(entry_maker, finder_args.entry_maker)

            -- Verify new_buffer_previewer was called by checking our flag
            assert.is_true(preview_called)

            -- Check that the options passed to pickers.new include a previewer
            assert.equals('mock_buffer_previewer', options_received.previewer)

            -- Verify find was called on the picker
            assert.stub(mock_finder.find).was_called(1)
        end)

        it('sets up selection handler that calls close and gets selected entry', function()
            -- Create a selection handler that we can spy on
            local selection_handler_spy = spy.new(function(bufnr, selection) end)
            local prompt_bufnr = 123

            telescope_provider.custom_picker({
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

            -- Check that attach_mappings exists and is a function
            assert.is_function(options_received.attach_mappings)

            -- Call attach_mappings which should set up the handler
            options_received.attach_mappings(prompt_bufnr, {})

            -- Make sure we captured a replacement function
            assert.is_function(replacement_fn)

            -- Execute the replacement function
            replacement_fn()

            -- Verify get_selected_entry was called
            assert.stub(telescope_stubs.actions_state.get_selected_entry).was_called(1)

            -- Verify actions.close was called with correct buffer number
            assert.stub(telescope_stubs.actions.close).was_called(1)
            assert.stub(telescope_stubs.actions.close).was_called_with(prompt_bufnr)

            -- Verify selection handler was called with the right arguments
            assert.spy(selection_handler_spy).was_called(1)
            assert.spy(selection_handler_spy).was_called_with(prompt_bufnr, { value = 'mock_selected_entry' })
        end)
    end)

    describe('command_map', function()
        it('returns the correct command mapping', function()
            local command_map = telescope_provider.command_map()

            -- Check a few common commands
            assert.equals('find_files', command_map.files)
            assert.equals('git_files', command_map.git_files)
            assert.equals('live_grep', command_map.live_grep)
            assert.equals('buffers', command_map.buffers)
            assert.equals('diagnostics', command_map.diagnostics)

            -- Check the number of commands
            local count = 0
            for _, _ in pairs(command_map) do
                count = count + 1
            end
            assert.equals(34, count)
        end)
    end)
end)
