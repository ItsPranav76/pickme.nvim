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
        files = 'files',
        git_files = 'git_files',
        live_grep = 'grep',
        grep_string = 'grep_word',
        buffers = 'buffers',
        help = 'help',
        diagnostics = 'diagnostics',
        commands = 'commands',
        git_branches = 'git_branches',
        git_status = 'git_status',
        git_commits = 'git_log',
        git_stash = 'git_stash',
        lsp_references = 'lsp_references',
        lsp_document_symbols = 'lsp_symbols',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        lsp_type_definitions = 'lsp_type_definitions',
        lsp_definitions = 'lsp_definitions',
        lsp_implementations = 'lsp_implementations',
        keymaps = 'keymaps',
        oldfiles = 'recent',
        registers = 'registers',
        marks = 'marks',
        highlights = 'highlights',
        colorschemes = 'colorschemes',
        command_history = 'command_history',
        search_history = 'search_history',
        spell_suggest = 'spelling',
        resume = 'resume',
        jumplist = 'jumps',
        quickfix = 'qflist',
        buffer_grep = 'lines',
        treesitter = 'treesitter',
        man_pages = 'man',
    }
end

return M
