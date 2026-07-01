#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${TMUX_WRAPPER_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/tmux-wrapper}"
BIN_DIR="${TMUX_WRAPPER_BIN_DIR:-$HOME/.local/bin}"
TMUX_CONF="$HOME/.tmux.conf"
BASH_RC="$HOME/.bashrc"
ZSH_RC="$HOME/.zshrc"
INSTALL_SHELL_HOOKS=1

usage() {
  cat <<EOF
Usage: bash install.sh [options]

Options:
  --no-shell-hooks       Do not modify .bashrc/.zshrc
  --config-dir <path>    Install config files to custom path
  --bin-dir <path>       Install tmwrap command to custom path
  -h, --help             Show this help
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-shell-hooks)
      INSTALL_SHELL_HOOKS=0
      shift
      ;;
    --config-dir)
      CONFIG_DIR="$2"
      shift 2
      ;;
    --bin-dir)
      BIN_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

backup_if_exists() {
  local file="$1"
  if [[ -f "$file" ]]; then
    local bak="${file}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$file" "$bak"
    echo "Backup: $bak"
  fi
}

ensure_line() {
  local file="$1"
  local line="$2"
  [[ -f "$file" ]] || touch "$file"
  grep -Fqx "$line" "$file" || printf '\n%s\n' "$line" >> "$file"
}

echo "Installing tmux-wrapper to: $CONFIG_DIR"
mkdir -p "$CONFIG_DIR/scripts" "$CONFIG_DIR/shell" "$BIN_DIR"

cp "$REPO_DIR/tmux.conf" "$CONFIG_DIR/tmux.conf"
cp "$REPO_DIR/shell/tmux-wrapper.sh" "$CONFIG_DIR/shell/tmux-wrapper.sh"
cp "$REPO_DIR/bin/tmwrap" "$BIN_DIR/tmwrap"
cp "$REPO_DIR/scripts/"*.sh "$CONFIG_DIR/scripts/"

chmod +x "$BIN_DIR/tmwrap" "$CONFIG_DIR/shell/tmux-wrapper.sh" "$CONFIG_DIR/scripts/"*.sh

if [[ ! -f "$TMUX_CONF" ]]; then
  touch "$TMUX_CONF"
fi

if ! grep -Fq 'tmux-wrapper/tmux.conf' "$TMUX_CONF"; then
  backup_if_exists "$TMUX_CONF"
  cat >> "$TMUX_CONF" <<EOF

# >>> tmux-wrapper >>>
source-file "$CONFIG_DIR/tmux.conf"
# <<< tmux-wrapper <<<
EOF
  echo "Updated $TMUX_CONF"
else
  echo "tmux-wrapper source already present in $TMUX_CONF"
fi

if [[ "$INSTALL_SHELL_HOOKS" -eq 1 ]]; then
  hook_line="[ -f \"$CONFIG_DIR/shell/tmux-wrapper.sh\" ] && . \"$CONFIG_DIR/shell/tmux-wrapper.sh\""
  ensure_line "$BASH_RC" "$hook_line"
  [[ -f "$ZSH_RC" ]] && ensure_line "$ZSH_RC" "$hook_line"
  echo "Shell hooks installed (bash + existing zsh)"
fi

echo "Installation complete"
echo "Next:"
echo "  1) source ~/.bashrc"
echo "  2) tmux source-file ~/.tmux.conf"
echo "  3) run: tmwrap doctor"
