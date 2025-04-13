local config = require('pickme.config')

---@class PickMe.Main
local M = {}

local fzf_lua_prompt_suffix = ' '

---@return function
local function get_picker_command(command, opts)
    local picker_provider = config.config.picker_provider

    if picker_provider == 'fzf-lua' and opts.title then
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
            mini = function()
                -- Mini.pick has no direct commands equivalent
                require('mini.pick').builtin.cli({
                    command = 'nvim -c "silent verbose command" -c "silent qall!" | grep -v "Last set"',
                    prefix = '',
                })
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
            mini = function()
                require('mini.pick').builtin.diagnostic(opts)
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
            mini = function()
                require('mini.pick').builtin.git_branches(opts)
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
            mini = function()
                require('mini.pick').builtin.git_status(opts)
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
            mini = function()
                require('mini.pick').builtin.git_commits(opts)
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
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'references' })
            end,
        },
        lsp_document_symbols = {
            snacks = function()
                require('snacks.picker').lsp_document_symbols(opts)
            end,
            telescope = function()
                require('telescope.builtin').lsp_document_symbols(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lsp_document_symbols(opts)
            end,
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'document_symbol' })
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
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'workspace_symbol' })
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
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'type_definition' })
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
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'definition' })
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
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'implementations' })
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
            mini = function()
                -- Mini.pick has no direct keymaps equivalent
                local cmd = 'nvim -c "silent! verbose map" -c "silent! qall!" | grep -v "Last set"'
                require('mini.pick').builtin.cli({ command = cmd, prefix = '' })
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
            mini = function()
                require('mini.pick').builtin.oldfiles(opts)
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
            mini = function()
                require('mini.pick').builtin.registers(opts)
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
            mini = function()
                require('mini.pick').builtin.marks(opts)
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
            mini = function()
                -- Mini.pick has no direct highlights equivalent
                local cmd = 'nvim -c "silent! highlight" -c "silent! qall!"'
                require('mini.pick').builtin.cli({ command = cmd, prefix = '' })
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
            mini = function()
                -- Mini.pick has no direct colorschemes equivalent
                require('mini.pick').builtin.cli({
                    command = "nvim --cmd 'echo getcompletion(\"\", \"color\")' --cmd 'q!' | grep -v '^\\s*$'",
                    processor = function(_, _, lines)
                        return vim.tbl_map(function(line)
                            return line:gsub('[%[%]\'" ,]', '')
                        end, lines)
                    end,
                    preview = function(entry)
                        return string.format('colorscheme %s', entry)
                    end,
                })
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
            mini = function()
                -- Mini.pick doesn't have a direct command_history equivalent
                require('mini.pick').builtin.pick({
                    source = function()
                        local history = {}
                        for i = 1, vim.fn.histnr(':') do
                            table.insert(history, vim.fn.histget(':', i))
                        end
                        return history
                    end,
                })
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
            mini = function()
                -- Mini.pick doesn't have a direct search_history equivalent
                require('mini.pick').builtin.pick({
                    source = function()
                        local history = {}
                        for i = 1, vim.fn.histnr('/') do
                            table.insert(history, vim.fn.histget('/', i))
                        end
                        return history
                    end,
                })
            end,
        },
        spell_suggest = {
            snacks = function()
                -- Snacks doesn't have a direct spell_suggest equivalent
                local word = vim.fn.expand('<cword>')
                local suggestions = vim.fn.spellsuggest(word)
                require('snacks.picker').pick({
                    items = vim.tbl_map(function(item)
                        return { text = item }
                    end, suggestions),
                    title = "Spelling Suggestions for '" .. word .. "'",
                    format = 'text',
                    confirm = function(_, selection)
                        vim.cmd('normal ciw' .. selection.text)
                    end,
                })
            end,
            telescope = function()
                require('telescope.builtin').spell_suggest(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').spell_suggest(opts)
            end,
            mini = function()
                local word = vim.fn.expand('<cword>')
                local suggestions = vim.fn.spellsuggest(word)
                require('mini.pick').builtin.pick({
                    source = suggestions,
                    options = {
                        prompt = 'Spell Suggestions: ' .. word,
                    },
                    choose = function(entry)
                        vim.cmd('normal ciw' .. entry)
                    end,
                })
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
            mini = function()
                -- Mini.pick doesn't have a resume function
                vim.notify('Resume not supported in mini.pick', vim.log.levels.WARN)
            end,
        },
        jumplist = {
            snacks = function()
                require('snacks.picker').jumplist(opts)
            end,
            telescope = function()
                require('telescope.builtin').jumplist(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').jumps(opts)
            end,
            mini = function()
                local jump_items = vim.fn.getjumplist()[1]
                local entries = {}
                for i, item in ipairs(jump_items) do
                    local bufname = vim.api.nvim_buf_get_name(item.bufnr)
                    if bufname and bufname ~= '' then
                        table.insert(entries, {
                            display = string.format('%d: %s:%d', i, vim.fn.fnamemodify(bufname, ':~:.'), item.lnum),
                            bufnr = item.bufnr,
                            lnum = item.lnum,
                            col = item.col,
                        })
                    end
                end

                require('mini.pick').builtin.pick({
                    source = entries,
                    choose = function(entry)
                        vim.api.nvim_set_current_buf(entry.bufnr)
                        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col })
                    end,
                })
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
            mini = function()
                local qf_items = vim.fn.getqflist()
                local entries = {}
                for _, item in ipairs(qf_items) do
                    local filename = vim.api.nvim_buf_get_name(item.bufnr)
                    local text = item.text or ''
                    table.insert(entries, {
                        display = string.format(
                            '%s:%d:%d: %s',
                            vim.fn.fnamemodify(filename, ':~:.'),
                            item.lnum,
                            item.col,
                            text
                        ),
                        filename = filename,
                        lnum = item.lnum,
                        col = item.col,
                    })
                end

                require('mini.pick').builtin.pick({
                    source = entries,
                    choose = function(entry)
                        vim.cmd(string.format('edit +%d %s', entry.lnum, entry.filename))
                        vim.api.nvim_win_set_cursor(0, { entry.lnum, entry.col - 1 })
                    end,
                })
            end,
        },
        tags = {
            snacks = function()
                require('snacks.picker').tags(opts)
            end,
            telescope = function()
                require('telescope.builtin').tags(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').tags(opts)
            end,
            mini = function()
                require('mini.pick').builtin.cli({
                    command = 'ctags -R . && cat tags | grep -v "^!_"',
                    processor = function(_, _, lines)
                        return lines
                    end,
                })
            end,
        },
        current_buffer_fuzzy_find = {
            snacks = function()
                require('snacks.picker').buffer_lines(opts)
            end,
            telescope = function()
                require('telescope.builtin').current_buffer_fuzzy_find(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').lgrep_curbuf(opts)
            end,
            mini = function()
                -- Mini.pick approximation using grep in current buffer
                local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
                require('mini.pick').builtin.pick({
                    source = lines,
                    options = {
                        prompt = 'Buffer Lines: ',
                    },
                    choose = function(entry, idx)
                        vim.api.nvim_win_set_cursor(0, { idx, 0 })
                    end,
                })
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
            mini = function()
                -- Mini.pick doesn't have direct treesitter support
                vim.notify('Treesitter picker not supported in mini.pick', vim.log.levels.WARN)
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
            mini = function()
                -- Mini.pick alternative implementation
                require('mini.pick').builtin.cli({
                    command = 'git stash list',
                    processor = function(_, _, lines)
                        return lines
                    end,
                    choose = function(entry)
                        local stash_name = entry:match('stash@{%d+}')
                        if stash_name then
                            vim.cmd('Git stash show -p ' .. stash_name)
                        end
                    end,
                })
            end,
        },
        man_pages = {
            snacks = function()
                require('snacks.picker').man_pages(opts)
            end,
            telescope = function()
                require('telescope.builtin').man_pages(opts)
            end,
            fzf_lua = function()
                require('fzf-lua').man_pages(opts)
            end,
            mini = function()
                -- Mini.pick doesn't have direct man pages support
                require('mini.pick').builtin.cli({
                    command = 'man -k . | sort',
                    processor = function(_, _, lines)
                        return vim.tbl_map(function(line)
                            return line:match('([^%s]+)')
                        end, lines)
                    end,
                    choose = function(entry)
                        vim.cmd('Man ' .. entry)
                    end,
                })
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
    find_files = 'files',
    grep = 'live_grep',
    grep_word = 'grep_string',
    buffer_lines = 'current_buffer_fuzzy_find',
    git_log = 'git_commits',
    help_tags = 'help',
    jumps = 'jumplist',
    qflist = 'quickfix',
    colorscheme = 'colorschemes',
}

M.pick = function(command, opts)
    if command_aliases[command] then
        command = command_aliases[command]
    end

    vim.schedule(function()
        local picker_cmd = get_picker_command(command, opts)
        picker_cmd()
    end)
end

M.get_commands = function()
    local commands = {
        'buffers',
        'colorschemes',
        'command_history',
        'commands',
        'current_buffer_fuzzy_find',
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
