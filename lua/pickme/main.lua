local config = require('pickme.config')

---@class PickMe.Main
local M = {}

local fzf_lua_prompt_suffix = ' '

---@return function
local function get_picker_command(command, opts)
    local picker_provider = opts.provider_override or config.config.picker_provider

    if picker_provider == 'fzf_lua' and opts.title then
        opts.prompt = opts.title .. fzf_lua_prompt_suffix
    end

    if picker_provider == 'telescope' and opts.title then
        opts.prompt_title = opts.title
    end

    local picker_commands = {
        git_files = {
            snacks = function()
                require('snacks.picker').git_files(opts)
            end,
            telescope = function()
                require('telescope.builtin').git_files(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').git_files(opts)
            end,
            mini = function()
                require('mini.pick').builtin.files(opts)
            end,
        },
        files = {
            snacks = function()
                require('snacks.picker').files(opts)
            end,
            telescope = function()
                require('telescope.builtin').find_files(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').files(opts)
            end,
            mini = function()
                require('mini.pick').builtin.files(opts)
            end,
        },
        live_grep = {
            snacks = function()
                require('snacks.picker').grep(opts)
            end,
            telescope = function()
                require('telescope.builtin').live_grep(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').live_grep(opts)
            end,
            mini = function()
                require('mini.pick').builtin.grep(opts)
            end,
        },
        grep_string = {
            snacks = function()
                require('snacks.picker').grep_word(opts)
            end,
            telescope = function()
                require('telescope.builtin').grep_string(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').grep_cword(opts)
            end,
            mini = function()
                local word = vim.fn.expand('<cword>')
                opts.pattern = word
                require('mini.pick').builtin.grep(opts)
            end,
        },
        buffers = {
            snacks = function()
                require('snacks.picker').buffers(opts)
            end,
            telescope = function()
                require('telescope.builtin').buffers(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').buffers(opts)
            end,
            mini = function()
                require('mini.pick').builtin.buffers(opts)
            end,
        },
        help = {
            snacks = function()
                require('snacks.picker').help(opts)
            end,
            telescope = function()
                require('telescope.builtin').help_tags(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').help_tags(opts)
            end,
            mini = function()
                require('mini.pick').builtin.help(opts)
            end,
        },
        commands = {
            snacks = function()
                require('snacks.picker').commands(opts)
            end,
            telescope = function()
                require('telescope.builtin').commands(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').commands(opts)
            end,
        },
        diagnostics = {
            snacks = function()
                require('snacks.picker').diagnostics(opts)
            end,
            telescope = function()
                require('telescope.builtin').diagnostics(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').diagnostics(opts)
            end,
        },
        git_branches = {
            snacks = function()
                require('snacks.picker').git_branches(opts)
            end,
            telescope = function()
                require('telescope.builtin').git_branches(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').git_branches(opts)
            end,
        },
        git_status = {
            snacks = function()
                require('snacks.picker').git_status(opts)
            end,
            telescope = function()
                require('telescope.builtin').git_status(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').git_status(opts)
            end,
        },
        git_commits = {
            snacks = function()
                require('snacks.picker').git_log(opts)
            end,
            telescope = function()
                require('telescope.builtin').git_commits(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').git_commits(opts)
            end,
        },
        lsp_references = {
            snacks = function()
                require('snacks.picker').lsp_references(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_references(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_references(opts)
            end,
        },
        lsp_document_symbols = {
            snacks = function()
                require('snacks.picker').lsp_symbols(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_document_symbols(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_document_symbols(opts)
            end,
        },
        lsp_workspace_symbols = {
            snacks = function()
                require('snacks.picker').lsp_workspace_symbols(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_workspace_symbols(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_workspace_symbols(opts)
            end,
        },
        lsp_type_definitions = {
            snacks = function()
                require('snacks.picker').lsp_type_definitions(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_type_definitions(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_typedefs(opts)
            end,
        },
        lsp_definitions = {
            snacks = function()
                require('snacks.picker').lsp_definitions(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_definitions(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_definitions(opts)
            end,
        },
        lsp_implementations = {
            snacks = function()
                require('snacks.picker').lsp_implementations(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_implementations(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_implementations(opts)
            end,
        },
        keymaps = {
            snacks = function()
                require('snacks.picker').keymaps(opts)
            end,
            telescope = function()
                require('telescope.builtin').keymaps(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').keymaps(opts)
            end,
        },
        oldfiles = {
            snacks = function()
                require('snacks.picker').recent(opts)
            end,
            telescope = function()
                require('telescope.builtin').oldfiles(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').oldfiles(opts)
            end,
        },
        registers = {
            snacks = function()
                require('snacks.picker').registers(opts)
            end,
            telescope = function()
                require('telescope.builtin').registers(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').registers(opts)
            end,
        },
        marks = {
            snacks = function()
                require('snacks.picker').marks(opts)
            end,
            telescope = function()
                require('telescope.builtin').marks(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').marks(opts)
            end,
        },
        highlights = {
            snacks = function()
                require('snacks.picker').highlights(opts)
            end,
            telescope = function()
                require('telescope.builtin').highlights(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').highlights(opts)
            end,
        },
        colorschemes = {
            snacks = function()
                require('snacks.picker').colorschemes(opts)
            end,
            telescope = function()
                require('telescope.builtin').colorscheme(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').colorschemes(opts)
            end,
        },
        command_history = {
            snacks = function()
                require('snacks.picker').command_history(opts)
            end,
            telescope = function()
                require('telescope.builtin').command_history(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').command_history(opts)
            end,
        },
        search_history = {
            snacks = function()
                require('snacks.picker').search_history(opts)
            end,
            telescope = function()
                require('telescope.builtin').search_history(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').search_history(opts)
            end,
        },
        spell_suggest = {
            snacks = function()
                require('snacks.picker').spelling(opts)
            end,
            telescope = function()
                require('telescope.builtin').spell_suggest(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').spell_suggest(opts)
            end,
        },
        resume = {
            snacks = function()
                require('snacks.picker').resume(opts)
            end,
            telescope = function()
                require('telescope.builtin').resume(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').resume(opts)
            end,
        },
        jumplist = {
            snacks = function()
                require('snacks.picker').jumps(opts)
            end,
            telescope = function()
                require('telescope.builtin').jumplist(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').jumps(opts)
            end,
        },
        quickfix = {
            snacks = function()
                require('snacks.picker').qflist(opts)
            end,
            telescope = function()
                require('telescope.builtin').quickfix(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').quickfix(opts)
            end,
        },
        tags = {
            telescope = function()
                require('telescope.builtin').tags(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').tags(opts)
            end,
        },
        buffer_grep = {
            snacks = function()
                require('snacks.picker').lines(opts)
            end,
            telescope = function()
                require('telescope.builtin').current_buffer_fuzzy_find(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lgrep_curbuf(opts)
            end,
        },
        treesitter = {
            snacks = function()
                require('snacks.picker').treesitter(opts)
            end,
            telescope = function()
                require('telescope.builtin').treesitter(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').treesitter(opts)
            end,
        },
        git_stash = {
            snacks = function()
                require('snacks.picker').git_stash(opts)
            end,
            telescope = function()
                require('telescope.builtin').git_stash(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').git_stash(opts)
            end,
        },
        man_pages = {
            snacks = function()
                require('snacks.picker').man(opts)
            end,
            telescope = function()
                require('telescope.builtin').man_pages(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').man_pages(opts)
            end,
        },
        select_file = {
            snacks = function()
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
            end,
            telescope = function()
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
            end,
            fzf_lua = function()
                require('fzf-lua').fzf_exec(opts.items, {
                    prompt = opts.title .. fzf_lua_prompt_suffix,
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
            end,
        },
        custom = {
            snacks = function()
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
            end,
            telescope = function()
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
            end,
            fzf_lua = function()
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
                    prompt = opts.title .. fzf_lua_prompt_suffix,
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
            end,
        },
    }

    if not picker_commands[command] then
        return function()
            vim.notify(
                "Picker command '" .. command .. "' not found. Check documentation for available commands.",
                vim.log.levels.ERROR
            )
        end
    end

    if not picker_commands[command][picker_provider] then
        return function()
            vim.notify(
                "Picker provider '" .. picker_provider .. "' does not support the '" .. command .. "' command.",
                vim.log.levels.ERROR
            )
        end
    end

    return picker_commands[command][picker_provider]
end

local command_aliases = {
    buffer_lines = 'buffer_grep',
    colorscheme = 'colorschemes',
    find_files = 'files',
    git_log = 'git_commits',
    grep = 'live_grep',
    grep_word = 'grep_string',
    help_tags = 'help',
    jumps = 'jumplist',
    qflist = 'quickfix',
}

M.pick = function(command, opts)
    opts = opts or {}
    if command_aliases[command] then
        command = command_aliases[command]
    end

    vim.schedule(function()
        local ok, picker_cmd = pcall(get_picker_command, command, opts)

        if ok and picker_cmd then
            picker_cmd()
        end
    end)
end

M.get_commands = function()
    local commands = {
        'buffer_grep',
        'buffers',
        'colorschemes',
        'command_history',
        'commands',
        'diagnostics',
        'files',
        'git_branches',
        'git_commits',
        'git_files',
        'git_stash',
        'git_status',
        'grep_string',
        'help',
        'highlights',
        'jumplist',
        'keymaps',
        'live_grep',
        'lsp_definitions',
        'lsp_document_symbols',
        'lsp_implementations',
        'lsp_references',
        'lsp_type_definitions',
        'lsp_workspace_symbols',
        'man_pages',
        'marks',
        'oldfiles',
        'quickfix',
        'registers',
        'resume',
        'search_history',
        'spell_suggest',
        'tags',
        'treesitter',
    }

    for alias, _ in pairs(command_aliases) do
        table.insert(commands, alias)
    end

    return commands
end

return M
