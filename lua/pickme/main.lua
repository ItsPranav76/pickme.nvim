local config = require('pickme.config')

---@class PickMe.Main
local M = {}

local fzf_lua_prompt_suffix = ' '

---@return function
local function get_picker_command(command, opts)
    local picker_provider = config.config.picker_provider

    local picker_commands = {
        git_files = {
            snacks = function()
                require('snacks.picker').git_files(opts)
            end,
            telescope = function()
                opts.prompt_title = opts.title
                require('telescope.builtin').git_files(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').find_files(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').live_grep(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
                require('fzf-lua').live_grep(opts)
            end,
            mini = function()
                require('mini.pick').builtin.grep(opts)
            end,
        },
        buffers = {
            snacks = function()
                require('snacks.picker').buffers(opts)
            end,
            telescope = function()
                opts.prompt_title = opts.title
                require('telescope.builtin').buffers(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').help_tags(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').commands(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').diagnostics(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').git_branches(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').git_status(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').git_commits(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').lsp_references(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').lsp_document_symbols(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').lsp_workspace_symbols(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
                require('fzf-lua').lsp_workspace_symbols(opts)
            end,
            mini = function()
                require('mini.pick').builtin.lsp({ scope = 'workspace_symbol' })
            end,
        },
        keymaps = {
            snacks = function()
                require('snacks.picker').keymaps(opts)
            end,
            telescope = function()
                opts.prompt_title = opts.title
                require('telescope.builtin').keymaps(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                require('snacks.picker').oldfiles(opts)
            end,
            telescope = function()
                opts.prompt_title = opts.title
                require('telescope.builtin').oldfiles(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').registers(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').marks(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').highlights(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').colorscheme(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').command_history(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').search_history(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').spell_suggest(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
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
                opts.prompt_title = opts.title
                require('telescope.builtin').resume(opts)
            end,
            fzf_lua = function()
                opts.prompt = opts.title .. fzf_lua_prompt_suffix
                require('fzf-lua').resume(opts)
            end,
            mini = function()
                -- Mini.pick doesn't have a resume function
                vim.notify('Resume not supported in mini.pick', vim.log.levels.WARN)
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
                opts.prompt_title = opts.title
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

    return picker_commands[command][picker_provider]
end

M.pick = function(command, opts)
    opts = opts or {}
    vim.schedule(function()
        local picker_cmd = get_picker_command(command, opts)
        picker_cmd()
    end)
end

return M
