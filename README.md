# PickMe.nvim: One Picker to Rule Them All 💍👑

![GitHub release](https://img.shields.io/github/release/ItsPranav76/pickme.nvim.svg)
![GitHub issues](https://img.shields.io/github/issues/ItsPranav76/pickme.nvim.svg)
![GitHub stars](https://img.shields.io/github/stars/ItsPranav76/pickme.nvim.svg)

Welcome to **PickMe.nvim**, your all-in-one picker for Neovim. This plugin combines the best features of various pickers, providing a streamlined experience for users. Whether you're searching files, selecting snippets, or exploring your codebase, PickMe has you covered.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Features

- **Unified Interface**: Access multiple pickers from a single command.
- **Fast Performance**: Built on top of `fzf-lua` for speedy selections.
- **Easy Integration**: Works seamlessly with other Neovim plugins like Telescope.
- **Customizable**: Tailor the experience to fit your workflow.
- **Lightweight**: Minimal setup required for maximum utility.

## Installation

To install PickMe.nvim, you can use your favorite package manager. Here’s how to do it with `Packer`:

```lua
use 'ItsPranav76/pickme.nvim'
```

After installation, you can download the latest release from [here](https://github.com/ItsPranav76/pickme.nvim/releases). Download the appropriate file and execute it to complete the setup.

## Usage

Once installed, you can start using PickMe with simple commands. Here are some common use cases:

- **Open File Picker**: Use the command `:PickFile` to browse your files.
- **Select Snippet**: Use `:PickSnippet` to choose from your saved snippets.
- **Search Symbols**: Use `:PickSymbol` to find symbols in your code.

You can combine these commands to create powerful workflows. For example, use the file picker to open a file and then immediately jump to a specific symbol.

## Configuration

PickMe.nvim offers various configuration options. You can customize the behavior by adding settings to your Neovim configuration file. Here’s a basic example:

```lua
require('pickme').setup {
  file_picker = {
    preview = true,
    hidden = true,
  },
  snippet_picker = {
    sort_by = 'date',
  },
}
```

### Options

- `file_picker`: Customize file selection settings.
- `snippet_picker`: Adjust snippet selection preferences.
- `preview`: Enable or disable file previews.
- `hidden`: Include hidden files in the selection.

Feel free to explore and adjust these settings to suit your needs.

## Contributing

We welcome contributions! If you’d like to help improve PickMe.nvim, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch to your forked repository.
5. Open a pull request with a description of your changes.

Your contributions help us make PickMe.nvim better for everyone!

## License

PickMe.nvim is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Contact

For questions or feedback, feel free to reach out:

- GitHub: [ItsPranav76](https://github.com/ItsPranav76)
- Email: pranav@example.com

## Conclusion

Thank you for checking out PickMe.nvim! We hope you find it useful in your Neovim workflow. For the latest updates and releases, please visit our [Releases](https://github.com/ItsPranav76/pickme.nvim/releases) section. Happy picking!