local pickme = require('pickme.main')
local config = require('pickme.config').config

local M = {}

M.setup = function()
    vim.api.nvim_create_user_command('Pick', function(opts)
        local args = opts.args
        if args == '' then
            print('Usage: Pick [picker_name] (e.g. Pick files, Pick live_grep)')
            return
        end

        local cmd = args:match('^(%S+)')
        local title_part = args:match('^%S+%s+(.*)')
        local title = title_part or cmd:gsub('_', ' '):gsub('^%l', string.upper)

        require('pickme').pick(cmd, { title = title })
    end, {
        nargs = '*',
        desc = 'Use any picker',
        complete = function(ArgLead, CmdLine, CursorPos)
            local pickers = pickme.get_commands()

            local matches = {}
            for _, picker in ipairs(pickers) do
                if picker:find(ArgLead, 1, true) then
                    table.insert(matches, picker)
                end
            end

            return matches
        end,
    })

    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        add_keymap('<leader>Th', ':PickMe files<CR>', 'Pick Files')
    end
end

return M
