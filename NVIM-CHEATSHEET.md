# Neovim + tmux cheat sheet

Launch Neovim from the project root so project search, LSP, Git, and sessions use the right workspace.

## Find what you need

| If you want to... | Go to... |
| --- | --- |
| Open a file or search words in the project | [Find files and text](#find-files-and-text) |
| Jump to code, references, or errors | [Navigate code](#navigate-code) |
| Switch files, close a tab, or split the screen | [Manage files and windows](#manage-files-and-windows) |
| Stage, commit, push, review changes, or fix conflicts | [Work with Git](#work-with-git) |
| Open a shell, run Lazygit, or keep a server running | [Use terminals](#use-terminals) and [Use tmux](#use-tmux) |
| Ask Copilot to explain, fix, or test code | [Use Copilot](#use-copilot) |
| Look up Space menus and submenus | [Space Menu Index](#space-menu-index) |
| Check language support or formatting | [Languages and tools](#languages-and-tools) |
| Change colors or see why Cmd keys are not working | [Appearance and shortcuts](#appearance-and-shortcuts) |

**New to the key notation?** `Space` means press the spacebar, then the next keys. For example, `Space g g` means tap Space, then `g`, then `g`. `Ctrl` and `Alt` are held while pressing the next key. In Neovim, `jj` leaves insert mode. If you forget a shortcut, press `Space` and pause to see the available choices.

## Space Menu Index

Press `Space` and pause to open WhichKey. Press a prefix and pause again to see
its submenu. Uppercase keys require `Shift` and are distinct from lowercase
keys. This index summarizes the configured menus; WhichKey shows the live
commands for the current filetype and buffer.

| Prefix | Menu | Look here for |
| --- | --- | --- |
| `a` | Copilot | Chat, Plan/Agent/Autopilot, model, code actions, Keep/Undo/Stop, voice |
| `b` | Buffers | Pick and close open files |
| `c` | Code | LSP actions, imports, rename, symbol outline |
| `d` | Debug | Breakpoints, debug controls, Go test debugging |
| `D` | Database | Database UI, add a connection, find a query buffer |
| `e` | Explorer | Project file tree |
| `f` | Files | File search and recent files |
| `g` | Git | Lazygit, hunks, diffs, history, conflicts, push/pull |
| `h` | Harpoon | Pin files and jump between them |
| `m` | Markdown | In-buffer rendering and browser preview (Markdown buffers) |
| `n` | Navigation/messages | Back/forward history and notification history |
| `q` | Sessions | Restore, select, or stop saving a project session |
| `r` | REST requests | Run/replay requests, select environment (HTTP/REST buffers) |
| `s` | Search | Project text, files, buffers, symbols, diagnostics |
| `t` | Terminals | Open layouts, choose/rename sessions, send code to shell |
| `u` | UI options | Auto-save, word wrap, themes, and other display toggles |
| `w` | Windows | Splits, tabs, window navigation |
| `x` | Diagnostics | Browse and filter errors and warnings |
| `z` | Horizontal scroll | Move left/right when word wrap is off |

Filetype menus are conditional: `m` preview actions require a Markdown buffer,
`r` requires an `.http` or `.rest` buffer, and Go test actions under `d` require
a Go file. The tables below give the most-used exact shortcuts in each menu.

### Specialty menu shortcuts

| Keys | Action |
| --- | --- |
| `Space d g t` / `Space d g l` | Debug a Go test / debug the last Go test again |
| `Space D` / `Space D a` / `Space D f` | Toggle database UI / add connection / find query buffer |
| `Space h a` / `Space h h` | Pin current file / open Harpoon list |
| `Space h p` / `Space h n` | Previous / next Harpoon file |
| `Space 1` through `Space 4` | Jump to a numbered Harpoon file |
| `Space n l` / `Space n h` / `Space n d` | Last notification / notification history / dismiss notifications |
| `Space q s` / `Space q S` | Restore this project session / choose a session |
| `Space q l` / `Space q d` | Restore most recent session / stop saving the current session |
| `Space r r` / `Space r l` | Run / replay an HTTP request |
| `Space r n` / `Space r p` | Next / previous request in an HTTP file |
| `Space r i` / `Space r c` / `Space r e` | Inspect request / copy as curl / choose request environment |

`D` and capital letters mean hold `Shift`. REST shortcuts only appear in `.http`
and `.rest` files. Database actions open the database UI; add a saved connection
there before trying to run queries.

## Everyday editing

| Action | Keys |
| --- | --- |
| Escape insert or visual mode | `jj` |
| Command palette | `Space s C` |
| Find files | `Cmd-P` or `Space Space` |
| Project text search | `Cmd-Shift-F` or `Space /` |
| Search word under cursor | `Space s w` |
| File explorer | `Space e` |
| Undo / redo | `u` / `Ctrl-r` |
| Save | `Space w` |
| Delete to line start | `Cmd-Backspace` |
| Toggle word wrap | `Space u w` |
| Scroll horizontally | `Space z h` / `Space z l` (10 columns) |
| Toggle auto-save | `Space u a` |
| Markdown in-buffer / browser preview | `Space m p` / `Space m b` |
| Quit | `Space q` |

## Find files and text

Use `Cmd-P` to open a file by name, or `Space Space` if the terminal does not pass Cmd keys to Neovim. Use `Cmd-Shift-F` or `Space /` to find text across the project. Type a few words to narrow results; press `Enter` to open a result and `Esc` to close the picker.

Search starts at the project root and respects `.gitignore`. `Space s w` searches for the word under the cursor. To search only the current directory, use `Space s G`.

## Navigate code

| Action | Keys |
| --- | --- |
| Definition | `F12` or `gd` |
| References | `Shift-F12` or `gr` |
| Implementation | `gI` |
| Type definition | `gy` |
| Hover docs | `K` |
| Rename symbol | `Space c R` |
| Code action | `Space c a` |
| Back / forward | `Cmd-J` / `Cmd-K` or `Space n b` / `Space n f` |
| Symbol outline | `Space c s` |
| Diagnostics list | `Space x x` |

When a language server is attached, `gr` finds references to a symbol; project text search is a fallback when no language server is available. Check attached servers with `:LspInfo`.

## Manage files and windows

| Action | Keys |
| --- | --- |
| Next / previous buffer | `Shift-L` / `Shift-H` |
| Pick an open buffer | `Space b b` |
| Pick a buffer to close | `Space b d` |
| Close current buffer | `Space b D` |
| Close other buffers | `Space b c` |
| Close buffers left / right | `Space b l` / `Space b r` |
| Add file to Harpoon | `Space h a` |
| Harpoon menu | `Space h h` |
| Jump to Harpoon file 1-4 | `Space 1` through `Space 4` |
| Vertical / horizontal split | `Space w v` / `Space w s` |
| Move between splits | `Ctrl-h/j/k/l` |
| New tab | `Space w t` |
| Close window | `Space w c` |
| Keep only current window | `Space w o` |

The teal `×` on a file tab closes that file. `Space b d` lets you choose a file to close; `Space b D` closes the current file. These close file buffers, not split windows. Use `Space w c` to close a split. One Dark Pro is the default transparent dark theme; `Space u D` reapplies it and `Space u L` switches to Catppuccin Latte.

In Telescope, press `Tab` to select several files, then `Ctrl-Q` to send them to
quickfix. Use `:copen` to inspect the list and `:cfdo edit` to open the selected
files in sequence. Harpoon is better for a small set of files you revisit often.

## Use terminals

| Action | Keys |
| --- | --- |
| Toggle floating terminal | `Ctrl-`` or `Space t t` |
| Horizontal terminal | `Space t h` |
| Vertical terminal | `Space t v` |
| Terminal in a full tab | `Space t f` |
| New terminal | `Space t n` |
| Pick / rename terminal session | `Space t P` / `Space t N` |
| Lazygit in terminal | `Space t g` |
| Lazygit floating UI | `Space g g` |
| Send current line | `Space t s` |
| Send visual selection | `Space t s` in visual mode |
| Return to normal mode without closing terminal | `Esc` |
| Hide terminal, keep session alive | `Ctrl-q` |
| Move from terminal to split | `Ctrl-h/j/k/l` |

`Space t n` creates a named floating shell. `Space t P` switches between open
sessions; `Space t N` renames the active session. The title bar shows the
session name and its `Esc` / `Ctrl-q` controls.

## Use Copilot

| Action | Keys |
| --- | --- |
| Accept inline suggestion | `Tab` |
| Accept word / line | `Ctrl-Right` / `Ctrl-Down` |
| Next / previous suggestion | `Alt-]` / `Alt-[` |
| Copilot Chat | `Space a c` |
| Choose model | `Space a m` |
| Choose mode | `Space a M` |
| Show active model and mode | `Space a S` |
| Open Plan mode | `Space a P` |
| Open chat in Autopilot mode | `Space a A` |
| Keep nearest Copilot diff | `Space a k` |
| Undo source-buffer change | `Space a u` |
| Stop active response | `Space a x` |
| Voice prompt (macOS Dictation) | `Space a v`, then `Ctrl-S` to send |
| Explain / fix selection | `Space a e` / `Space a f` |
| Generate tests | `Space a t` |
| Review selection | `Space a r` |
| Ask inline | `Space a i` |

Run `:Copilot auth` once, then `:Copilot status` to check the connection.

Ask mode starts with no callable tools. Plan mode reads workspace context and
returns a plan without editing or running shell commands. Agent mode offers
workspace tools but asks before each action. Autopilot automatically reads and
searches workspace files and applies edits; shell commands and URL fetches still
require approval. Project instructions are read from `.github/copilot-instructions.md`,
`copilot-instructions.md`, and `AGENTS.md` when present. Choose a model that
supports tool calls for Agent or Autopilot. The chat winbar shows the active mode
and model. Keep applies the nearest suggested diff; Undo uses Neovim undo in the
source buffer. Dictation uses macOS voice input, then `Ctrl-S` submits the prompt.

## Extra search tools

Neovim uses Telescope with `fd` for files and `rg` for text. Search respects
ignore files and starts at the detected project root. Useful direct commands:

- `:Telescope find_files`
- `:Telescope live_grep`
- `:Telescope buffers`
- `:Telescope commands`
- `:Telescope diagnostics`

The standalone `fzf` executable is also installed for shell workflows. In a
shell, `fzf` filters a list interactively; pipe files or history into it, for
example `rg --files | fzf`.

## Work with Git

| Action | Shortcut |
| --- | --- |
| Open Git changes (Lazygit, like VS Code Source Control) | `Space g g` |
| Stage block at cursor / selected lines | `Space g s` |
| Stage whole current file | `Space g S` |
| Unstage file in Lazygit | Select file, press `Space` |
| Discard current block / unstaged file changes | `Space g h r` / `Space g h R` |
| Pull with rebase / push | `Space g j` / `Space g k` |
| Open Fugitive status / stage current file | `Space g F` / `Space g w` |
| Diff changes / file history / repo history | `Space g D` / `Space g H` / `Space g R` |

To stage only a block, put the cursor in it and press `Space g s`. Or select
the lines with `V` (whole lines) or `v` (characters), then press the same keys.
To stage the whole file, press `Space g S`. These match VS Code's **Stage
Hunk/Selected Ranges** and **Stage Changes** actions. `Space g g` opens Lazygit,
the closest match to the Source Control view; press `?` there for its shortcuts.

**Unstage** keeps your edits but removes them from the next commit. In Lazygit,
select the staged file and press `Space`. Git equivalent: `git restore --staged
-- <file>`. **Discard** removes edits. `Space g h r` discards the current block;
`Space g h R` discards unstaged edits in the current file. To restore a file
completely to the latest commit, including discarding staged changes, run
`:Git restore --source=HEAD --staged --worktree -- <file>` in Neovim. This is
destructive; inspect the file first.

The Git commands above are equivalents, not necessarily the exact subprocess
for each plugin action. Lazygit and Fugitive run Git operations; Gitsigns reads
diffs and stages selected patches. No Git hook is involved.

## Languages and tools

| Working on... | Included support |
| --- | --- |
| JavaScript, TypeScript, React | Language server, ESLint, Prettier, Tailwind, Emmet and JSX tag closing |
| Lua / this Neovim config | Lua language server and Stylua formatter |
| Go | `gopls`, Go imports/formatting and debugger support |
| Python | Pyright, Ruff and debugger support |
| C# / .NET | OmniSharp, C# formatter and debugger support |
| JSON, YAML, TOML, Docker | Language servers, schemas or file-specific support |

Open a file in a supported project to activate its language tools. Blink shows
completion suggestions and documentation as you type; press `Ctrl-Space` to
open suggestions manually. TypeScript inlay hints show parameter, property,
return, and variable types. Use `Space c M` to add missing imports and `Space c o`
to organize imports. For Markdown, `Space m p` renders headings, code, and tables
inside the buffer; `Space m b` opens a live browser preview. `Space c a` opens
code actions, `Space c R` renames a symbol, and `Space c f` formats when a
formatter is available. `:Mason` shows installed tools; `:LspInfo` shows active
language servers. Diagnostics appear inline and in `Space x x`.

## Appearance and shortcuts

One Dark Pro is the default, with transparent background, brighter foreground
and comments, and a vivid green block cursor in both normal and insert mode.
Use `Space u D` to reapply the dark theme or `Space u L` for Catppuccin Latte.
`Space u C` opens the theme picker (Tokyo Night, Kanagawa, Rose Pine, GitHub,
and other installed themes). To change the startup theme, edit `colorscheme` in
`lua/plugins/ui.lua`.

### Cmd keys in VS Code

When the VS Code terminal has focus, `Cmd+J`, `Cmd+K`, `Cmd+P`,
`Cmd+Shift+F`, and `Cmd+Backspace` are forwarded to Neovim (works inside tmux
too). `Cmd+Backspace` deletes to the start of the current line. In a plain shell
these keys do nothing useful. Click the editor area to use VS Code's own bindings. If the mappings do not work in the terminal, use `Space n b` / `Space n f` for back / forward, `Space Space` to find a file, and `Space /` to search text.

### If a shortcut is missing

Press `Space` and pause: which-key shows available actions. The command picker is `Space s C`; search there when you know what a command does but not its shortcut. For a full list, run `:WhichKey`.

## Use tmux

Start or reattach the work session with `tmux new -A -s work`. The config lives
at `~/.tmux.conf` and uses `Ctrl-Space` as its prefix.

| Action | Keys |
| --- | --- |
| Split left/right | `Prefix` then `|` |
| Split top/bottom | `Prefix` then `-` |
| Navigate panes | `Prefix` then `h/j/k/l` or `Alt-h/j/k/l` |
| New window | `Prefix` then `c` |
| Next / previous window | `Prefix` then `n` / `p` |
| Rename window | `Prefix` then `,` |
| Detach | `Prefix` then `d` |
| Reload config | `Prefix` then `r` |

Use Neovim's integrated terminal for short-lived commands and tmux for shells,
servers, logs, or long-running processes that should survive closing Neovim.
