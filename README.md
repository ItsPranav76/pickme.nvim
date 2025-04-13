<div align = "center">

<h1><a href="https://github.com/2kabhishek/pickme.nvim">pickme.nvim</a></h1>

<a href="https://github.com/2KAbhishek/pickme.nvim/blob/main/LICENSE">
<img alt="License" src="https://img.shields.io/github/license/2kabhishek/pickme.nvim?style=flat&color=eee&label="> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/graphs/contributors">
<img alt="People" src="https://img.shields.io/github/contributors/2kabhishek/pickme.nvim?style=flat&color=ffaaf2&label=People"> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/stargazers">
<img alt="Stars" src="https://img.shields.io/github/stars/2kabhishek/pickme.nvim?style=flat&color=98c379&label=Stars"></a>

<a href="https://github.com/2KAbhishek/pickme.nvim/network/members">
<img alt="Forks" src="https://img.shields.io/github/forks/2kabhishek/pickme.nvim?style=flat&color=66a8e0&label=Forks"> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/watchers">
<img alt="Watches" src="https://img.shields.io/github/watchers/2kabhishek/pickme.nvim?style=flat&color=f5d08b&label=Watches"> </a>

<a href="https://github.com/2KAbhishek/pickme.nvim/pulse">
<img alt="Last Updated" src="https://img.shields.io/github/last-commit/2kabhishek/pickme.nvim?style=flat&color=e06c75&label="> </a>

<h3>Ready to go Neovim template 🏗️✈️</h3>

<figure>
  <img src="doc/images/screenshot.png" alt="pickme.nvim in action">
  <br/>
  <figcaption>pickme.nvim in action</figcaption>
</figure>

</div>

# pickme.nvim

A unified interface for multiple Neovim picker plugins.

## Overview

`pickme.nvim` provides a consistent API to work with different picker plugins in Neovim. It currently supports:

- [Snacks.picker](https://github.com/folke/snacks.nvim/blob/main/docs/picker.md)
- [Telescope](https://github.com/nvim-telescope/telescope.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [mini.pick](https://github.com/echasnovski/mini.pick)

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  '2KAbhishek/pickme.nvim',
  dependencies = {
    -- Include at least one of these pickers:
    -- 'folke/snacks.nvim', -- For snacks.picker
    -- 'nvim-telescope/telescope.nvim', -- For telescope
    -- 'ibhagwan/fzf-lua', -- For fzf-lua
    -- 'echasnovski/mini.pick', -- For mini.pick
  }
}
```

## Configuration

```lua
require('pickme').setup({
  -- Choose your preferred picker provider
  picker_provider = 'snacks', -- Options: 'snacks' (default), 'telescope', 'fzf_lua', 'mini'
})
```

## Available Pickers

All these pickers are available through a unified interface regardless of the underlying provider:

### Files and Navigation

- `files` - Find files in the current directory
- `git_files` - Find files tracked by Git
- `buffers` - Browse and select open buffers
- `oldfiles` - Browse recently opened files
- `live_grep` - Search for a string in your project (grep)
- `grep_string` - Search for the word under cursor
- `current_buffer_fuzzy_find` - Search within the current buffer
- `tags` - Browse ctags

### Git Integration

- `git_branches` - View and checkout git branches
- `git_status` - View files with git status changes
- `git_commits` - Browse git commit history
- `git_stash` - Browse git stash entries

### LSP Features

- `lsp_references` - Find references to the symbol under cursor
- `lsp_document_symbols` - List symbols in current document
- `lsp_workspace_symbols` - Search through workspace symbols
- `lsp_definitions` - Go to definition of the symbol under cursor
- `lsp_implementations` - Find implementations of the interface under cursor
- `lsp_type_definitions` - Find type definitions
- `diagnostics` - View and navigate diagnostic messages

### Neovim Functionality

- `commands` - Browse available commands
- `help` - Search through help tags
- `marks` - View and jump to marks
- `registers` - View contents of registers
- `keymaps` - Browse configured key mappings
- `highlights` - Browse highlight groups
- `colorschemes` - Preview and apply colorschemes
- `man_pages` - Browse man pages
- `jumplist` - Navigate through jump history
- `quickfix` - Browse quickfix list items
- `treesitter` - Navigate treesitter symbols

### History and Resume

- `command_history` - View command history
- `search_history` - View search history
- `spell_suggest` - Get spelling suggestions for word under cursor
- `resume` - Resume the last picker

### Custom Pickers

- `select_file` - Custom file picker with provided items
- `custom` - Fully customizable picker with custom items and handlers

## Usage

```lua
local pickme = require('pickme')

-- Basic usage
pickme.pick('files', { title = 'Find Files' })
pickme.pick('live_grep', { title = 'Search Text' })

-- With additional options
pickme.pick('git_branches', {
  title = 'Git Branches',
  -- Additional options are passed to the underlying picker
})

-- Using custom picker
pickme.pick('custom', {
  title = 'My Custom Picker',
  items = {'item1', 'item2', 'item3'},
  entry_maker = function(item)
    return { display = item, value = item }
  end,
  preview_generator = function(item)
    return "Preview content for " .. item
  end,
  preview_ft = 'markdown',
  selection_handler = function(_, selection)
    print("Selected: " .. selection.value)
  end
})
```

## Key Mappings

Example key mappings:

```lua
local pickme = require('pickme')

vim.keymap.set('n', '<leader>ff', function() pickme.pick('files', { title = 'Find Files' }) end, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', function() pickme.pick('live_grep', { title = 'Search Text' }) end, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>fb', function() pickme.pick('buffers', { title = 'Buffers' }) end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fh', function() pickme.pick('help', { title = 'Help Tags' }) end, { desc = 'Help Tags' })
vim.keymap.set('n', '<leader>fc', function() pickme.pick('commands', { title = 'Commands' }) end, { desc = 'Commands' })
vim.keymap.set('n', '<leader>fd', function() pickme.pick('diagnostics', { title = 'Diagnostics' }) end, { desc = 'Diagnostics' })
```

## License

Open source under the MIT License.

## ✨ Features

- Includes a ready to go neovim plugin template
- Comes with a lint and test CI action
- Includes a Github action to auto generate vimdocs
- Comes with a ready to go README template
- Works with [mkrepo](https://github.com/2kabhishek/mkrepo)

## ⚡ Setup

### ⚙️ Requirements

- Latest version of `neovim`

### 💻 Installation

```lua
-- Lazy
{
    '2kabhishek/pickme.nvim',
    cmd = 'TemplateHello',
    -- Add your custom configs here, keep it blank for default configs (required)
    opts = {},
    -- Use this for local development
    -- dir = '~/path-to/pickme.nvim',
},
```

## 🚀 Usage

1. Fork the `pickme.nvim` repo
2. Update the plugin name, file names etc, change `template` to `your-plugin-name`
3. Add the code required for your plugin,
   - Code entrypoint is [template.lua](./lua/template.lua)
   - Add user configs to [config.lua](./lua/template/config.lua)
   - For adding commands and keybindngs use [commands.lua](./lua/template/commands.lua)
   - Separate plugin logic into modules under [modules](./lua/template/) dir
4. Add test code to the [tests](./tests/) directory
5. Update the README
6. Tweak the [docs action](./.github/workflows/docs.yml) file to reflect your plugin name, commit email and username
   - Generating vimdocs needs read and write access to actions (repo settings > actions > general > workflow permissions)

### Configuration

pickme.nvim can be configured using the following options:

```lua
template.setup({
    name = 'pickme.nvim', -- Name to be greeted, 'World' by default
})
```

### Commands

`pickme.nvim` adds the following commands:

- `TemplateHello`: Shows a hello message with the confugred name.

### Keybindings

It is recommended to use:

- `<leader>th,` for `TemplateHello`

> NOTE: By default there are no configured keybindings.

### Help

Run `:help template.txt` for more details.

## 🏗️ What's Next

Planning to add `<feature/module>`.

### ✅ To-Do

- [x] Setup repo
- [ ] Think real hard
- [ ] Start typing

## ⛅ Behind The Code

### 🌈 Inspiration

pickme.nvim was inspired by [nvim-plugin-template](https://github.com/ellisonleao/nvim-plugin-template), I added some changes on top to make setting up a new plugin faster.

### 💡 Challenges/Learnings

- The main challenges were `<issue/difficulty>`
- I learned about `<learning/accomplishment>`

### 🧰 Tooling

- [dots2k](https://github.com/2kabhishek/dots2k) — Dev Environment
- [nvim2k](https://github.com/2kabhishek/nvim2k) — Personalized Editor
- [sway2k](https://github.com/2kabhishek/sway2k) — Desktop Environment
- [qute2k](https://github.com/2kabhishek/qute2k) — Personalized Browser

### 🔍 More Info

- [nerdy.nvim](https://github.com/2kabhishek/nerdy.nvim) — Find nerd glyphs easily
- [tdo.nvim](https://github.com/2KAbhishek/tdo.nvim) — Fast and simple notes in Neovim
- [termim.nvim](https://github.com/2kabhishek/termim.nvim) — Neovim terminal improved
- [octohub.nvim](https://github.com/2kabhishek/octohub.nvim) — Github repos in Neovim
- [exercism.nvim](https://github.com/2kabhishek/exercism.nvim) — Exercism exercises in Neovim

<hr>

<div align="center">

<strong>⭐ hit the star button if you found this useful ⭐</strong><br>

<a href="https://github.com/2KAbhishek/pickme.nvim">Source</a>
| <a href="https://2kabhishek.github.io/blog" target="_blank">Blog </a>
| <a href="https://twitter.com/2kabhishek" target="_blank">Twitter </a>
| <a href="https://linkedin.com/in/2kabhishek" target="_blank">LinkedIn </a>
| <a href="https://2kabhishek.github.io/links" target="_blank">More Links </a>
| <a href="https://2kabhishek.github.io/projects" target="_blank">Other Projects </a>

</div>
