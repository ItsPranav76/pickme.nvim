local M = {}

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    require('telescope.pickers')
        .new({}, {
            prompt_title = opts.prompt_title,
            finder = require('telescope.finders').new_table({
                results = opts.items,
                entry_maker = require('telescope.make_entry').gen_from_file(),
            }),
            sorter = require('telescope.sorters').get_fzy_sorter(),
            previewer = require('telescope.previewers').vim_buffer_cat.new({}),
        })
        :find()
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    require('telescope.pickers')
        .new({}, {
            prompt_title = opts.title,
            finder = require('telescope.finders').new_table({
                results = opts.items,
                entry_maker = opts.entry_maker,
            }),
            sorter = require('telescope.sorters').get_generic_fuzzy_sorter(),
            previewer = require('telescope.previewers').new_buffer_previewer({
                define_preview = function(self, entry, _)
                    local repo_info = opts.preview_generator(entry.value)
                    vim.bo[self.state.bufnr].filetype = opts.preview_ft or 'markdown'
                    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(repo_info, '\n'))
                end,
            }),
            attach_mappings = function(prompt_bufnr, _)
                require('telescope.actions').select_default:replace(function()
                    local selection = require('telescope.actions.state').get_selected_entry()
                    require('telescope.actions').close(prompt_bufnr)
                    opts.selection_handler(prompt_bufnr, selection)
                end)
                return true
            end,
        })
        :find()
end

M.command_map = function()
    return {
        files = 'find_files',
        git_files = 'git_files',
        live_grep = 'live_grep',
        grep_string = 'grep_string',
        buffers = 'buffers',
        help = 'help_tags',
        diagnostics = 'diagnostics',
        commands = 'commands',
        git_branches = 'git_branches',
        git_status = 'git_status',
        git_commits = 'git_commits',
        git_stash = 'git_stash',
        lsp_references = 'lsp_references',
        lsp_document_symbols = 'lsp_document_symbols',
        lsp_workspace_symbols = 'lsp_workspace_symbols',
        lsp_type_definitions = 'lsp_type_definitions',
        lsp_definitions = 'lsp_definitions',
        lsp_implementations = 'lsp_implementations',
        keymaps = 'keymaps',
        oldfiles = 'oldfiles',
        registers = 'registers',
        marks = 'marks',
        highlights = 'highlights',
        colorschemes = 'colorscheme',
        command_history = 'command_history',
        search_history = 'search_history',
        spell_suggest = 'spell_suggest',
        resume = 'resume',
        jumplist = 'jumplist',
        quickfix = 'quickfix',
        tags = 'tags',
        buffer_grep = 'current_buffer_fuzzy_find',
        treesitter = 'treesitter',
        man_pages = 'man_pages',
    }
end

return M
