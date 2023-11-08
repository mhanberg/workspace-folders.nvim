# workspace-folders.nvim

`.code-workspace` file support and utilities for managing your multi-root workspace.

## Install

### lazy.nvim

```lua
{
  "mhanberg/workspace-folders.nvim",
  event = "VimEnter"
}
```

## Usage

Upon startup, it will read a `.code-workspace` file found in your repository and set the contents, along with its name, to the `vim.g.workspace` global variable.

You can then use that variable when starting up your language servers.

`.code-workspace` are simple JSON structures, consider the file `nx.code-workspace`:

```json
{
  "folders": [
    { "path": "nx" },
    { "path": "exla" },
    { "path": "torchx" }
  ]
}
```
