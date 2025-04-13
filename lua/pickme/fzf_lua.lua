local M = {}

---@param opts PickMe.SelectFileOptions
M.select_file = function(opts)
    require('fzf-lua').fzf_exec(opts.items, {
        prompt = opts.title,
        file_icons = true,
        previewer = 'builtin',
        file_skip_empty_lines = true,
        actions = {
            ['default'] = function(selected)
                if selected and #selected > 0 then
                    vim.cmd('edit ' .. vim.fn.fnameescape(selected[1]))
                end
            end,
        },
    })
end

---@param opts PickMe.CustomPickerOptions
M.custom_picker = function(opts)
    local formatted_items = {}
    local item_map = {}
    for _, item in ipairs(opts.items) do
        local entry = opts.entry_maker(item)
        table.insert(formatted_items, entry.display)
        item_map[entry.display] = item
    end

    local CustomPreviewer = require('fzf-lua.previewer.builtin').base:extend()
    function CustomPreviewer:new(o, preview_opts, fzf_win)
        CustomPreviewer.super.new(self, o, preview_opts, fzf_win)
        setmetatable(self, CustomPreviewer)
        self.item_map = item_map
        return self
    end

    function CustomPreviewer:populate_preview_buf(entry_str)
        local bufnr = self:get_tmp_buffer()
        local item = self.item_map[entry_str]
        local preview_text = opts.preview_generator(item)
        local lines = vim.split(preview_text, '\n')
        vim.bo[bufnr].filetype = opts.preview_ft or 'markdown'
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

        self:set_preview_buf(bufnr)
        if self.win and type(self.win.update_scrollbar) == 'function' then
            self.win:update_scrollbar()
        end
    end

    require('fzf-lua').fzf_exec(formatted_items, {
        prompt = opts.title,
        previewer = CustomPreviewer,
        actions = {
            ['default'] = function(selected)
                if selected and #selected > 0 then
                    local item = item_map[selected[1]]
                    if item then
                        opts.selection_handler(nil, { value = item })
                    end
                end
            end,
        },
    })
end

M.command_map = function()
    return {
        files = 'files',
        git_files = 'git_files',
        live_grep = 'live_grep',
        grep_string = 'grep_cword',
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
        lsp_type_definitions = 'lsp_typedefs',
        lsp_definitions = 'lsp_definitions',
        lsp_implementations = 'lsp_implementations',
        keymaps = 'keymaps',
        oldfiles = 'oldfiles',
        registers = 'registers',
        marks = 'marks',
        highlights = 'highlights',
        colorschemes = 'colorschemes',
        command_history = 'command_history',
        search_history = 'search_history',
        spell_suggest = 'spell_suggest',
        resume = 'resume',
        jumplist = 'jumps',
        quickfix = 'quickfix',
        tags = 'tags',
        buffer_grep = 'lgrep_curbuf',
        treesitter = 'treesitter',
        man = 'man_pages',
    }
end

return M
