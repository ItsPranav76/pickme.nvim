local assert = require('luassert.assert')
local spy = require('luassert.spy')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

describe('pickme.snacks', function()
    local mock_picker = {}
    local orig_require = _G.require

    -- Properly mock the required modules and global objects
    before_each(function()
        -- Create a basic vim mock if needed
        _G.vim = vim or {}
        _G.vim.cmd = vim.cmd or function() end
        _G.vim.tbl_map = vim.tbl_map
            or function(fn, t)
                local result = {}
                for i, v in ipairs(t) do
                    result[i] = fn(v)
                end
                return result
            end

        -- Create the mock picker with a proper spy function
        mock_picker.pick = spy.new(function(options)
            -- Store the options so we can inspect them later
            mock_picker._last_options = options
        end)

        -- Create global Snacks object
        _G.Snacks = {
            picker = {
                format = {
                    file = 'file_format',
                    text = 'text_format',
                },
                actions = {
                    jump = 'jump_action',
                },
            },
        }

        -- Override require
        _G.require = function(module)
            if module == 'snacks.picker' then
                return mock_picker
            else
                return orig_require(module)
            end
        end
    end)

    after_each(function()
        _G.require = orig_require
        _G.Snacks = nil
    end)

    describe('select_file', function()
        it('calls picker.pick with correct arguments', function()
            local snacks = require('pickme.snacks')
            local files = { 'file1.txt', 'file2.lua' }

            -- Clear any previous calls
            mock_picker._last_options = nil

            snacks.select_file({
                items = files,
                title = 'Test Files',
            })

            -- Verify the spy was called
            assert.spy(mock_picker.pick).was_called()

            -- Get the options that were passed
            local options = mock_picker._last_options

            -- Verify the options table
            assert.is_table(options)
            assert.equals('Test Files', options.title)
            assert.equals('file_format', options.format)
            assert.equals('jump_action', options.actions.confirm)
            assert.equals(2, #options.items)
        end)
    end)

    describe('custom_picker', function()
        it('calls picker.pick with transformed items', function()
            local snacks = require('pickme.snacks')
            local items = {
                { id = 1, name = 'Item 1' },
                { id = 2, name = 'Item 2' },
            }

            -- Clear any previous calls
            mock_picker._last_options = nil

            snacks.custom_picker({
                items = items,
                title = 'Test Custom Picker',
                entry_maker = function(item)
                    return { display = item.name, value = item.id }
                end,
                preview_generator = function(item)
                    return 'Preview for ' .. item.name
                end,
                preview_ft = 'text',
                selection_handler = function() end,
            })

            -- Verify the spy was called
            assert.spy(mock_picker.pick).was_called()

            -- Get the options that were passed
            local options = mock_picker._last_options

            -- Verify the options table
            assert.is_table(options)
            assert.equals('Test Custom Picker', options.title)
            assert.equals('text_format', options.format)
            assert.equals('preview', options.preview)
            assert.equals(2, #options.items)
        end)
    end)

    describe('command_map', function()
        it('returns the correct command mapping', function()
            local snacks = require('pickme.snacks')
            local command_map = snacks.command_map()

            -- Check a few common commands
            assert.equals('files', command_map.files)
            assert.equals('git_files', command_map.git_files)
            assert.equals('grep', command_map.live_grep)
            assert.equals('buffers', command_map.buffers)
            assert.equals('diagnostics', command_map.diagnostics)

            -- Check the number of commands
            local count = 0
            for _, _ in pairs(command_map) do
                count = count + 1
            end
            assert.equals(33, count)
        end)
    end)
end)
