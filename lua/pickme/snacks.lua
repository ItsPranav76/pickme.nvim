local M = {}

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    require('snacks.picker').pick({
        items = vim.tbl_map(function(item)
            return { file = item }
        end, opts.items),
        title = opts.title,
        format = Snacks.picker.format.file,
        actions = {
            confirm = Snacks.picker.actions.jump,
        },
    })
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    require('snacks.picker').pick({
        items = vim.tbl_map(function(item)
            return {
                text = opts.entry_maker(item).display,
                value = item,
                preview = {
                    text = opts.preview_generator(item),
                    ft = opts.preview_ft or 'markdown',
                },
            }
        end, opts.items),
        title = opts.title,
        format = Snacks.picker.format.text,
        preview = 'preview',
        actions = {
            confirm = function(_, selected)
                if selected and selected.value then
                    vim.cmd('close')
                    opts.selection_handler(nil, { value = selected.value })
                end
            end,
        },
    })
end

M.command_map = function()
    return {
        autocmds = 'autocmds',
        buffer_grep = 'lines',
        buffers = 'buffers',
        cliphist = 'cliphist',
        colorschemes = 'colorschemes',
        command_history = 'command_history',
        commands = 'commands',
        diagnostics = 'diagnostics',
        diagnostics_buffer = 'diagnostics_buffer',
        files = 'files',
        git_branches = 'git_branches',
        git_commits = 'git_log',
        git_files = 'git_files',
        git_log = 'git_bcommits',
        git_log_file = 'git_log_file',
        git_log_line = 'git_log_line',
        git_stash = 'git_stash',
        git_status = 'git_status',
        grep_buffers = 'grep_buffers',
        grep_string = 'grep_word',
        help = 'help',
        highlights = 'highlights',
        icons = 'icons',
        jumplist = 'jumps',
        keymaps = 'keymaps',
        lazy = 'lazy',
        live_grep = 'grep',
        loclist = 'loclist',
        lsp_config = 'lsp_config',
        lsp_declarations = 'lsp_declarations',
        lsp_definitions = 'lsp_definitions',
        lsp_document_symbols = 'lsp_symbols',
        lsp_implementations = 'lsp_implementations',
        lsp_references = 'lsp_references',
        lsp_type_definitions = 'lsp_type_definitions',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        man = 'man',
        marks = 'marks',
        notifications = 'notifications',
        oldfiles = 'recent',
        pickers = 'pickers',
        projects = 'projects',
        quickfix = 'qflist',
        registers = 'registers',
        resume = 'resume',
        search_history = 'search_history',
        spell_suggest = 'spelling',
        treesitter = 'treesitter',
        undo = 'undo',
        zoxide = 'zoxide',
    }
end

return M
