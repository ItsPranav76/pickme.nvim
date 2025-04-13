local main = require('pickme.main')

local M = {}

M.setup = function(opts)
    require('pickme.config').setup(opts)
    require('pickme.commands').setup()
end

M.pick = function(command, opts)
    return main.pick(command, opts)
end

M.select_file = function(opts)
    return main.select_file(opts)
end

M.custom_picker = function(opts)
    return main.custom_picker(opts)
end

return M
