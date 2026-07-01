# tmux-wrapper

A portable tmux setup with a modern workflow out of the box.

## Features

- Interactive session picker for attach/create
- In-tmux session switcher
- Dashboard for sessions, windows, and panes
- Clean keybindings for rename, navigation, and layout actions
- Shell helpers for daily use
- Editor terminal environment passthrough for older tmux panes
- Save Terminals through tmux when running VS Code / Cursor with SSH extension

## Requirements

- Required: tmux
- Recommended: fzf
- Optional: xclip (clipboard copy integration in tmux copy mode)

## Quick Start

```bash
git clone <your-repo-url> tmux-wrapper
cd tmux-wrapper
bash install.sh
source ~/.bashrc
tmwrap doctor
```

## Installation Details

By default, the installer:

- Copies config and scripts to ~/.config/tmux-wrapper/
- Installs tmwrap to ~/.local/bin/tmwrap
- Appends a source-file block to ~/.tmux.conf (with backup)
- Adds shell helper source line to ~/.bashrc (and ~/.zshrc if present)

Install options:

```bash
bash install.sh --no-shell-hooks
bash install.sh --config-dir "$HOME/.config/my-tmux-wrapper"
bash install.sh --bin-dir "$HOME/bin"
```

## Commands

Shell helpers:

```bash
tm                 # session picker (attach/create)
ta work            # attach/create session "work"
tls                # list sessions
tnew demo          # create detached session
tmux-dashboard     # open dashboard
fixvscode          # refresh editor IPC env in old tmux pane
```

CLI command:

```bash
tmwrap attach [name]
tmwrap switch
tmwrap dashboard
tmwrap help
tmwrap reload
tmwrap doctor
```

## What tmwrap doctor Checks

tmwrap doctor validates local installation and dependencies.

It checks:

- tmux is installed and available in PATH
- wrapper config file exists in the install location
- required wrapper scripts exist and are executable
- fzf availability (warning only, not a hard failure)
- whether ~/.tmux.conf sources tmux-wrapper

If required checks fail, doctor exits with a non-zero status.

## Default Keybindings

Prefix is Ctrl+b.

- Prefix + Ctrl+f: switch session
- Prefix + D: open dashboard
- Prefix + ?: open quick help popup
- Prefix + r: reload tmux config
- Prefix + | or Prefix + -: split panes
- Alt + arrows: pane navigation
- Prefix + $: rename session
- Prefix + ,: rename window
- Prefix + P: rename pane title

## Troubleshooting

- Command not found: tmwrap
	- Ensure your bin directory is in PATH (for example ~/.local/bin)
- Dashboard/session picker opens without fuzzy UI
	- Install fzf for interactive filtering
- copy-mode clipboard does not work
	- Install xclip
- Existing tmux shell does not see new helpers
	- Run source ~/.bashrc and reload tmux config

## Uninstall (manual)

1. Remove install directory:
	 - rm -rf ~/.config/tmux-wrapper
2. Remove tmwrap binary:
	 - rm -f ~/.local/bin/tmwrap
3. Remove tmux-wrapper source block from ~/.tmux.conf
4. Remove shell hook line from ~/.bashrc and ~/.zshrc if added

## License

MIT
