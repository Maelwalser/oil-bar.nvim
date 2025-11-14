# oil-bar.nvim
An extension for [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim) that provides a persistent sidebar toggle and context-aware navigation.

## Features

https://github.com/user-attachments/assets/9ef89f96-75f9-473c-a261-8b43a9fb9ee2



- **Persistent Sidebar Toggle**: A simple command (<leader>e by default) to open and close oil.nvim in a persistent vertical split on the far left.

- **Context-Aware Navigation**: The <CR> keymap is enhanced to be "sidebar-aware":

- **In the sidebar**: Opens directories within the sidebar, and opens files in the main content window (to the right).

- **In a normal oil buffer**: <CR> retains its default oil.nvim behavior.

- **Intelligent File Opening**: Files opened from the sidebar are automatically opened in a window to the right, creating a new vertical split if one doesn't already exist.

- **Focus Retention**: When opening a file from the sidebar, focus immediately returns to the sidebar, allowing you to continue browsing without interruption.

- **Decoupled Configuration**: This plugin does not manage or override your personal oil.nvim configuration. It simply adds the toggle functionality and the smart <CR> keymap.

## Requirements
- neovim/nvim-lsp (v0.8+)

- stevearc/oil.nvim

## Installation & Configuration
Here is an example using lazy.nvim.

```lua
return {
  "maelwalser/oil-bar.nvim",
  dependencies = { "stevearc/oil.nvim" },
  opts = {
    -- keymap = "<leader>p" -- Uncomment and change to your preferred key
  },
}
```

## Usage
Once installed, the plugin provides new behaviors.

**Global**
- Press <leader>e (or your custom keymap) to toggle the oil.nvim sidebar on and off.

**In the Oil Sidebar**
- Place your cursor on a directory and press <CR> to navigate into that directory within the sidebar.

- Place your cursor on a file and press <CR> to open that file in a window to the right. Focus will remain on the sidebar.

**In a Normal oil Buffer**
- Press <CR> on any entry to use the default oil.nvim "select" action (e.g., opening the file or directory in the current window).
