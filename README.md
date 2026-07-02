# 🎯 tmux-wrapper

> **A modern, battery-included tmux setup for power users.** Drop-in configuration with intuitive keybindings, interactive dashboards, and shell helpers that make terminal multiplexing enjoyable.

---

## ✨ What Makes tmux-wrapper Great?

### 🚀 **Interactive Dashboard**
Manage all your tmux sessions, windows, and panes in one beautiful fzf-powered interface. Rename, kill, create, or jump to any target with keyboard shortcuts.

### 🎮 **Thoughtful Keybindings**
Intuitive keyboard shortcuts that feel natural:
- `Prefix + D` → Open interactive dashboard ta
- `Prefix + N` → Create new window in current directory
- `Prefix + ,` → Rename window
- `Alt + Arrows` → Navigate panes seamlessly
- `Prefix + Ctrl+F` → Switch sessions instantly

### 💬 **Smart Session Management**
- `tm` → Interactive session picker (create or attach)
- `ta work` → Quick attach/create by name
- `tls` → List all sessions
- `tnew demo` → Create detached sessions

### 🎨 **Modern Theme Out-of-the-Box**
Beautiful Catppuccin color scheme with:
- Clean status bar (session name, time, hostname)
- Syntax-highlighted window tabs
- Smart pane borders with active indicators
- Color-coded messages

### 🖱️ **Mouse Support**
- Click to switch windows/panes
- Right-click context menus
- Scroll in copy mode
- Drag to resize panes

### 📋 **VS Code/Cursor Terminal Integration**
Automatically preserves editor environment variables in tmux panes for seamless Git, SSH, and debugging workflows.

---

## 📋 Requirements

- **Required:** tmux (3.0+)
- **Recommended:** fzf (for interactive filtering)
- **Optional:** xclip (for clipboard integration in copy mode)

---

## 📸 Screenshots

### Dashboard View
![Dashboard Screenshot](./screenshots/dashboard.png)
*The interactive dashboard lets you manage sessions, windows, and panes. Press `r` to rename, `R` for window, `x` to kill, or `Enter` to jump.*

**What to capture:**
- Open tmux session with multiple windows/panes
- Press `Prefix + D` to show dashboard popup
- Show the fzf interface with the list of panes
- Capture the header showing available commands (r, R, p, x, w, K, n, N)

---

### Status Bar & Window Tabs
![Status Bar Screenshot](./screenshots/status-bar.png)
*Clean, modern status bar with session name, window tabs, hostname, date, and time. Right-click any tab for context menu.*

**What to capture:**
- Full tmux window showing the top status bar
- Multiple window tabs with different names
- Show the right-click context menu (right-click on a tab)
- The time/date display on the right side

---

### Pane Navigation
![Pane Navigation Screenshot](./screenshots/pane-navigation.png)
*Multiple panes with clear borders and active indicator. Use `Alt + Arrow` keys to navigate smoothly.*

**What to capture:**
- A tmux window split into 2-4 panes
- Show pane borders are clearly visible
- Highlight the active pane with bright border
- Demonstrate different pane layouts (horizontal, vertical, grid)

---

### Session Picker
![Session Picker Screenshot](./screenshots/session-picker.png)
*Quick session switching with `tm` command or `Prefix + Ctrl+F`.*

**What to capture:**
- Run `tm` from terminal (outside tmux)
- Show the fzf picker with multiple sessions listed
- Demonstrate filtering by typing
- Show preview panel

---

## 🚀 Installation

### One-liner:
```bash
git clone https://github.com/yourusername/tmux-wrapper.git ~/.config/tmux-wrapper-src && \
cd ~/.config/tmux-wrapper-src && bash install.sh
```

### Step-by-step:
```bash
# Clone the repository
git clone https://github.com/yourusername/tmux-wrapper.git
cd tmux-wrapper

# Run installer
bash install.sh

# Source shell configuration
source ~/.bashrc

# Verify installation
tmwrap doctor
```

### Advanced Installation Options:
```bash
# Custom config directory
bash install.sh --config-dir "$HOME/.tmux-custom"

# Custom bin directory
bash install.sh --bin-dir "$HOME/bin"

# Skip shell hooks (manual setup required)
bash install.sh --no-shell-hooks
```

---

## ⌨️ Keybindings

| Keybinding | Action |
|---|---|
| `Prefix + D` | Open interactive dashboard |
| `Prefix + Ctrl+F` | Switch sessions |
| `Prefix + N` | New window in current directory |
| `Prefix + ,` | Rename current window |
| `Prefix + $` | Rename session |
| `Prefix + P` | Rename pane title |
| `Prefix + \|` | Split pane (horizontal) |
| `Prefix + -` | Split pane (vertical) |
| `Alt + ↑↓←→` | Navigate between panes |
| `Prefix + r` | Reload config |
| `Prefix + ?` | Show help popup |

---

## 🛠️ Commands

### Shell Helpers (Quick Access)
```bash
tm              # Interactive session picker
ta work         # Attach/create session "work"
tls             # List all sessions
tnew demo       # Create new detached session
tmux-dashboard  # Open dashboard
fixvscode       # Refresh VS Code terminal env
```

### CLI Interface
```bash
tmwrap attach [name]    # Attach to session with picker
tmwrap switch           # Switch session (inside tmux)
tmwrap dashboard        # Open dashboard
tmwrap help             # Show keybindings
tmwrap reload           # Reload config
tmwrap doctor           # Validate installation
```

---

## 🔍 Dashboard Features

The interactive dashboard (`Prefix + D`) gives you full control:

| Key | Action |
|---|---|
| `Enter` | Jump to selected pane |
| `r` | Rename session |
| `R` | Rename window |
| `p` | Rename pane title |
| `x` | Kill pane |
| `w` | Kill window |
| `K` | Kill session |
| `n` | Create new session |
| `N` | Create new window |

**Type to search** any session/window/pane name in real-time. The preview panel shows the current path.

---

## 📦 What Gets Installed

```
~/.config/tmux-wrapper/
├── tmux.conf              # Main configuration
├── scripts/
│   ├── dashboard.sh       # Interactive dashboard
│   ├── session-picker.sh  # Session picker
│   ├── session-switcher.sh # In-tmux switcher
│   ├── help-popup.sh      # Keybindings help
│   └── rename-target.sh   # Rename utilities
└── shell/
    └── tmux-wrapper.sh    # Shell helpers

~/.local/bin/tmwrap       # Main CLI command
```

---

## 🔧 Validation & Troubleshooting

### Check Your Installation
```bash
tmwrap doctor
```

This validates:
- ✓ tmux is installed
- ✓ Configuration file exists
- ✓ All scripts are executable
- ✓ fzf is available (recommended)
- ✓ ~/.tmux.conf sources tmux-wrapper

### Common Issues

**Command `tmwrap` not found**
```bash
# Make sure ~/.local/bin is in PATH
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

**Dashboard appears without fzf UI**
```bash
# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

**Clipboard not working in copy mode**
```bash
# Install xclip
sudo apt install xclip  # Ubuntu/Debian
brew install xclip      # macOS (via Homebrew)
```

**Shell helpers not available in new terminal**
```bash
# Source bashrc in new shell
source ~/.bashrc
# Or reload tmux config
tmux source-file ~/.tmux.conf
```

---

## 🎨 Customization

### Modify Colors
Edit `~/.config/tmux-wrapper/tmux.conf` and change the Catppuccin palette:
```tmux
# Current: Catppuccin Mocha theme
set -g status-style "bg=#1e1e2e,fg=#cdd6f4"

# To change to your theme, update hex colors
```

### Add Custom Keybindings
Add to your `~/.tmux.conf` after the tmux-wrapper source:
```tmux
# My custom bindings
bind C-d kill-session  # Quick kill session
bind l send-keys "clear" Enter  # Clear screen
```

### Extend with Custom Scripts
Create `~/.config/tmux-wrapper/scripts/my-script.sh` and call it:
```tmux
bind X run-shell -b "~/.config/tmux-wrapper/scripts/my-script.sh"
```

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- Built on [tmux](https://github.com/tmux/tmux)
- UI powered by [fzf](https://github.com/junegunn/fzf)
- Styled with [Catppuccin](https://catppuccin.com) theme
- Inspired by modern terminal workflows

---

**Happy multiplexing! 🚀**
