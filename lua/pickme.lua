return {
    setup = function(opts)
        require('pickme.config').setup(opts)
        require('pickme.commands').setup()
    end,
}
