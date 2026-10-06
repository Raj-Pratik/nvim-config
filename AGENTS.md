# Neovim Configuration Instructions

- Keep `init.lua` as the entrypoint. Put shared editor behavior in `lua/config/` (`options.lua`, `keymaps.lua`, `autocmds.lua`) and plugin setup in the appropriate `lua/plugins/*.lua` spec.
- Manage LazyVim extras in `lazyvim.json`. Preserve upstream defaults when extending plugin option lists; prefer an `opts` function with `vim.list_extend` over replacing the list.
- Respect lazy-loading conditions (`event`, `ft`, `cmd`, `keys`) and branches for `vim.g.vscode`. Verify behavior in the relevant filetype, command, or VS Code Neovim environment, not only on startup.
- Keep both standalone Neovim and VS Code Neovim behavior in mind. In particular, Copilot Chat intentionally uses VS Code's native chat inside VS Code and the Neovim client standalone; see [README.md](README.md).
- Document every new user-facing feature, command, workflow, or shortcut in the task-oriented [NVIM-CHEATSHEET.md](NVIM-CHEATSHEET.md), with exact keys and what it does. Update [README.md](README.md) as well when its overview or setup guidance is affected.
- Prefix every new custom keybinding with the Space leader (`<leader>`). Do not add new unprefixed or direct Cmd/Ctrl/Alt mappings; check the mapping in every affected mode, including terminal mode where applicable.
- Avoid unrelated changes to `lazy-lock.json`; it pins plugin revisions. Lua style is two-space indentation with a 120-column width, configured in `stylua.toml`.
- There is no checked-in test runner. Validate Lua edits with a focused `nvim --headless` check or startup check, and use `stylua --check <changed-file>` when Stylua is installed. Exercise lazy-loaded behavior explicitly; startup alone may not load it.
- Neovim 0.11+ is required by the documented setup. See [README.md](README.md) for dependencies, runtime behavior, and [NVIM-CHEATSHEET.md](NVIM-CHEATSHEET.md) for shortcut workflows.