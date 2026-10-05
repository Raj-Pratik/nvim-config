# Neovim Configuration

LazyVim with VS Code-style search, code navigation, Copilot, and Vim bindings.
The leader key is Space. Launch `nvim` from your project directory.

Need a shortcut by task? Start with the [Neovim + tmux cheat sheet](NVIM-CHEATSHEET.md). It includes a Space-prefix index; press `Space` in Neovim and pause to see the live WhichKey options, then press a prefix and pause for its submenu.

## Shortcuts

| Action | Shortcut | Terminal-friendly alternative |
| --- | --- | --- |
| Return to normal mode (insert or visual) | `jj` | `Esc` |
| Search text across project files | `Cmd+Shift+F` | `Space /` or `Space s g` |
| Find files | `Cmd+P` | `Space Space` |
| Command palette | `Space s C` | |
| Go to definition | `F12` | `gd` |
| Find symbol references | `Shift+F12` | `gr` or `Space c r` |
| Search the word under the cursor | `Space s w` | |
| Go to implementation | `gI` | |
| Go to type definition | `gy` | |
| Hover documentation | `K` | |
| Rename symbol | `Space c R` | |
| Code actions | `Space c a` | |
| Navigate back / forward | `Cmd+J` / `Cmd+K` | `Space n b` / `Space n f`, or `Ctrl+O` / `Ctrl+I` |
| Delete to line start | `Cmd+Backspace` | In insert and normal mode |
| Toggle word wrap | `Space u w` | |
| Scroll horizontally | `Space z h` / `Space z l` | 10 columns left / right; wrap must be off |
| Toggle auto-save | `Space u a` | Starts enabled; saves after a short pause |
| Markdown preview | `Space m p` / `Space m b` | Render in Neovim / open browser preview |
| Toggle terminal panel | `Cmd+H` | `Space t h` |
| Copilot Chat | `Space a c` | `:CopilotChat` |
| Choose Copilot model / mode | `Space a m` / `Space a M` | |
| Start Copilot Plan mode | `Space a P` | Read-only planning |
| Start chat in Autopilot mode | `Space a A` | |
| Keep / undo Copilot diff | `Space a k` / `Space a u` | |
| Stop Copilot response | `Space a x` | |
| Voice prompt | `Space a v` | macOS Dictation, then `Ctrl+S` |
| Accept Copilot suggestion | `Tab` | |
| Explain / fix selected code | `Space a e` / `Space a f` | |
| File explorer | `Space e` | |
| Next / previous open file | `Shift+L` / `Shift+H` | |
| Pick or close an open file | `Space b b` / `Space b d` | |
| Close current file | `Space b D` | |
| Lazygit | `Space g g` | `Space t g` |
| New terminal | `Space t n` | `Ctrl+`` |
| Vertical / horizontal split | `Space w v` / `Space w s` | |
| New tab / close window | `Space w t` / `Space w c` | |

In the VS Code terminal, `Cmd+J`, `Cmd+K`, `Cmd+P`, and `Cmd+Shift+F` are
forwarded to Neovim. Use `Space s C` for the command picker. See the
[cheat sheet](NVIM-CHEATSHEET.md) for task-based instructions and alternatives.

## Search and References

Telescope searches the detected project root, not just the current file's
directory. Text search uses `ripgrep`, includes hidden files, respects ignore
files, and excludes `.git` and `node_modules`. Use `Space s G` to search the
current working directory instead. Search results can be sent to the quickfix
list with `Ctrl+Q` or to Trouble with `Ctrl+T`.

Text search finds literal occurrences. `gr` finds semantic references using the
attached language server, including references in other project files. It
requires a supported language and a correctly detected project root. Use
`:LspInfo` to inspect attached servers and `:Mason` to inspect installed tools.
References outside the language server's workspace cannot be guaranteed.

## Copilot

Inline suggestions and Copilot Chat are configured. Run `:Copilot auth` once
and finish GitHub authentication in your browser; a Copilot entitlement is
required. Run `:Copilot status` to check the connection.

Copilot uses its standalone server, downloaded on first load, so it does not
require upgrading your project's Node.js 20 runtime to Node.js 22. Suggestions
are enabled for code and Markdown, but disabled for plain text and commit
messages, matching the local VS Code settings. Next-edit suggestions remain off.
The chat winbar shows the selected model and mode. Ask disables callable tools;
Agent requires approval for tool calls; Autopilot automatically reads, searches,
and edits workspace files while keeping shell commands approval-gated. Plan
reads project context and returns a plan without edits or shell commands. The
project instruction paths `.github/copilot-instructions.md`,
`copilot-instructions.md`, and `AGENTS.md` are included in chat prompts when
present. Use `Space a k` to apply the nearest suggested diff, `Space a u` to
undo a source-buffer change, and `Space a x` to stop a response. `Space a v`
opens chat for macOS Dictation; press `Ctrl+S` to submit the dictated prompt.
Use a tool-capable model for Agent or Autopilot.

## Completion and Markdown

Blink shows completion suggestions and documentation while typing; press
`Ctrl+Space` to open the menu manually. TypeScript inlay hints show parameter,
property, return, and variable types. Use `Space c M` to add missing imports and
`Space c o` to organize imports. For Markdown, `Space m p` toggles styled
rendering inside the buffer; `Space m b` opens a live browser preview.

## Dependencies

Neovim 0.11+, `git`, `fd`, `ripgrep`, `make`, `curl`, and `unzip` are used by
the configured navigation and Copilot plugins. Mason manages language servers;
individual servers may also require Node.js, Go, or .NET.

Lazygit is built into current LazyVim's Snacks integration. There is no
`lazyvim.plugins.extras.editor.lazygit` extra. Install the `lazygit` executable
to use `Space g g`.

VS Code fonts and font ligatures are controlled by the terminal or GUI, not
this Neovim configuration. VS Code extensions and MCP integrations are not
automatically shared with Neovim.

## Terminal and tmux

The repository includes a tmux setup at `~/.tmux.conf`. Start it with
`tmux new -A -s work`; the prefix is `Ctrl-Space`.

| Action | Shortcut |
| --- | --- |
| Split left/right | `Prefix` then `|` |
| Split top/bottom | `Prefix` then `-` |
| Move between panes | `Prefix` then `h/j/k/l` or `Alt+h/j/k/l` |
| Create window | `Prefix` then `c` |
| Next / previous window | `Prefix` then `n` / `p` |
| Rename window | `Prefix` then `,` |
| Detach session | `Prefix` then `d` |
| Reload tmux config | `Prefix` then `r` |

Use Neovim's terminal shortcuts inside a tmux pane when you need an integrated
editor terminal. Use tmux panes when you want a persistent shell, server, logs,
or a second editor session beside Neovim.

The integrated terminal supports named sessions (`Space t n`), session picking
(`Space t P`), and renaming (`Space t N`). Press `Esc` to return to Neovim normal
mode without closing the shell; `Ctrl+q` hides the terminal and keeps the
session alive. `Space u a` toggles debounced file auto-save; special buffers are
excluded.

One Dark Pro is the default transparent dark theme, with brighter text and
comments. Use `Space u D` for the dark theme and `Space u L` for Catppuccin
Latte. The cursor is a block in both normal and insert mode.
