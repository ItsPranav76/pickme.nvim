local assert = require('luassert.assert')
local spy = require('luassert.spy')
local describe = require('plenary.busted').describe
local it = require('plenary.busted').it
local before_each = require('plenary.busted').before_each
local after_each = require('plenary.busted').after_each

local fzf_lua_provider = require('pickme.fzf_lua')

describe('pickme.fzf_lua', function()
    local mock_fzf_lua = {
        fzf_exec = function() end,
        previewer = {
            builtin = {
                base = {
                    extend = function()
                        return {
                            new = function()
                                return {}
                            end,
                            super = {
                                new = function()
                                    return {}
                                end,
                            },
                            __call = function()
                                return {}
                            end,
                            __index = {
                                get_tmp_buffer = function()
                                    return 1
                                end,
                                populate_preview_buf = function() end,
                                set_preview_buf = function() end,
                            },
                        }
                    end,
                },
            },
        },
    }

    local fzf_exec_calls = {}
    local orig_require = _G.require

    before_each(function()
        fzf_exec_calls = {}

        mock_fzf_lua.fzf_exec = function(items, options)
            table.insert(fzf_exec_calls, {
                items = items,
                options = options,
            })
        end

        _G.require = function(module_name)
            if module_name == 'fzf-lua' then
                return mock_fzf_lua
            elseif module_name == 'fzf-lua.previewer.builtin' then
                return mock_fzf_lua.previewer.builtin
            else
                return orig_require(module_name)
            end
        end

        vim.fn = vim.fn or {}
        vim.fn.fnameescape = function(s)
            return s
        end

        vim.bo = vim.bo
            or setmetatable({}, {
                __index = function()
                    return {}
                end,
            })

        vim.api = vim.api or {}
        vim.api.nvim_buf_set_lines = function() end
    end)

    after_each(function()
        _G.require = orig_require
    end)

    describe('select_file', function()
        it('calls fzf_exec with correct options', function()
            local test_files = { 'file1.txt', 'path/to/file2.lua', 'another/file3.md' }
            local test_title = 'Select a File'

            fzf_lua_provider.select_file({
                items = test_files,
                title = test_title,
            })

            assert.equals(1, #fzf_exec_calls)
            local call = fzf_exec_calls[1]

            assert.same(test_files, call.items)

            assert.equals(test_title, call.options.prompt)
            assert.is_true(call.options.file_icons)
            assert.equals('builtin', call.options.previewer)

            local actions_fn = call.options.actions.default
            assert.is_function(actions_fn)

            local orig_vim_cmd = vim.cmd
            local cmd_calls = {}
            vim.cmd = function(cmd)
                table.insert(cmd_calls, cmd)
            end

            actions_fn({ 'selected_file.txt' })
            assert.equals(1, #cmd_calls)
            assert.equals('edit selected_file.txt', cmd_calls[1])

            vim.cmd = orig_vim_cmd
        end)

        it('handles empty selection in default action', function()
            fzf_lua_provider.select_file({
                items = { 'file1.txt', 'file2.txt' },
                title = 'Test',
            })

            local actions_fn = fzf_exec_calls[1].options.actions.default

            local orig_vim_cmd = vim.cmd
            local cmd_called = false
            vim.cmd = function(_)
                cmd_called = true
            end

            actions_fn({})
            assert.is_false(cmd_called)

            vim.cmd = orig_vim_cmd
        end)
    end)

    describe('custom_picker', function()
        it('calls fzf_exec with transformed items and custom previewer', function()
            local extend_spy = spy.on(mock_fzf_lua.previewer.builtin.base, 'extend')

            local test_items = {
                { id = 1, name = 'Item 1' },
                { id = 2, name = 'Item 2' },
                { id = 3, name = 'Item 3' },
            }

            local entry_maker = function(item)
                return {
                    display = item.name,
                    value = item.id,
                }
            end

            local preview_generator = function(item)
                return 'Preview for Item ' .. item.id
            end

            local selection_handler_called = false
            local selection_handler = function(_, selection)
                selection_handler_called = true
            end

            fzf_lua_provider.custom_picker({
                items = test_items,
                title = 'Custom Picker',
                entry_maker = entry_maker,
                preview_generator = preview_generator,
                preview_ft = 'markdown',
                selection_handler = selection_handler,
            })

            assert.spy(extend_spy).was_called()

            assert.equals(1, #fzf_exec_calls)
            local call = fzf_exec_calls[1]

            assert.equals(3, #call.items)
            assert.equals('Item 1', call.items[1])
            assert.equals('Item 2', call.items[2])
            assert.equals('Item 3', call.items[3])

            assert.equals('Custom Picker', call.options.prompt)
            assert.is_function(call.options.actions.default)

            local default_action = call.options.actions.default
            default_action({ 'Item 1' })

            assert.is_true(selection_handler_called)

            extend_spy:revert()
        end)

        it('handles empty selection in default action', function()
            local selection_handler_called = false
            local selection_handler = function(_, selection)
                selection_handler_called = true
            end

            fzf_lua_provider.custom_picker({
                items = { 'item1', 'item2' },
                title = 'Custom Picker',
                entry_maker = function(item)
                    return { display = item, value = item }
                end,
                preview_generator = function(item)
                    return 'Preview'
                end,
                selection_handler = selection_handler,
            })

            local default_action = fzf_exec_calls[1].options.actions.default
            default_action({})

            assert.is_false(selection_handler_called)
        end)
    end)
end)
