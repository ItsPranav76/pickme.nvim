local main = require('pickme.main')

local M = {}

M.setup = function(opts)
    require('pickme.config').setup(opts)
    require('pickme.commands').setup()
end

M.pick = function(command, opts)
    return main.pick(command, opts)
end

return M
