local pickme = require('pickme.main')
local config = require('pickme.config').config

local M = {}

M.setup = function()
    vim.api.nvim_create_user_command('PickMe', function(opts)
        local args = opts.args
        if args == '' then
            print('Usage: PickMe [picker_name] [provider] [title] (e.g. PickMe files snacks File picker)')
            return
        end

        local parts = {}
        for word in args:gmatch('%S+') do
            table.insert(parts, word)
        end

        local cmd = parts[1]
        local provider_override = parts[2]
        local title = table.concat(parts, ' ', 3)

        local picker_opts = {}

        if provider_override then
            picker_opts.provider_override = provider_override
        end

        if title ~= '' then
            picker_opts.title = title
        end

        require('pickme').pick(cmd, picker_opts)
    end, {
        nargs = '*',
        desc = 'Use any picker with optional provider override',
        complete = function(ArgLead, CmdLine, CursorPos)
            local parts = {}
            for word in CmdLine:gsub('^%s*PickMe%s+', ''):gmatch('%S+') do
                table.insert(parts, word)
            end

            if #parts == 0 then
                local pickers = pickme.get_commands()
                local matches = {}
                for _, picker in ipairs(pickers) do
                    if picker:find(ArgLead, 1, true) == 1 then
                        table.insert(matches, picker)
                    end
                end
                return matches
            end

            return {}
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
