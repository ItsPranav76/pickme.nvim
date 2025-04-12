local pickme = require('pickme.main')
local config = require('pickme.config').config

local M = {}

M.setup = function()
    vim.api.nvim_create_user_command('PickMe', function(opts)
        pickme.pick(opts.args)
    end, { nargs = '?' })

    if config.add_default_keybindings then
        local function add_keymap(keys, cmd, desc)
            vim.api.nvim_set_keymap('n', keys, cmd, { noremap = true, silent = true, desc = desc })
        end

        add_keymap('<leader>Th', ':PickMe files<CR>', 'Pick Files')
    end
end

return M
