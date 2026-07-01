#!/usr/bin/env bash
# Shell helpers for tmux-wrapper.

if [[ -n "${TMUX_WRAPPER_LOADED:-}" ]]; then
  return 0
fi
export TMUX_WRAPPER_LOADED=1

TMUX_WRAPPER_HOME="${TMUX_WRAPPER_HOME:-${XDG_CONFIG_HOME:-$HOME/.config}/tmux-wrapper}"
TMUX_WRAPPER_SCRIPTS="$TMUX_WRAPPER_HOME/scripts"

tm() { "$TMUX_WRAPPER_SCRIPTS/session-picker.sh" "$@"; }
ta() { tm "$@"; }

tls() {
  tmux list-sessions -F '#{?session_attached,*, } #{session_name}  [#{session_windows} windows]' 2>/dev/null || true
}

tnew() {
  local name="${1:-work}"
  local dir="${2:-$PWD}"
  tmux new-session -d -s "$name" -c "$dir" && echo "Created session: $name"
}

trename() {
  local target="${1:-}"
  local new_name="${2:-}"
  if [[ -z "$new_name" ]]; then
    read -r -e -p "New session name: " new_name
  fi
  [[ -n "$new_name" ]] && tmux rename-session -t "${target:-}" "$new_name"
}

trnwin() {
  read -r -e -i "$(tmux display -p '#W' 2>/dev/null)" -p "Window name: " n
  [[ -n "${n:-}" ]] && tmux rename-window "$n"
}

trnpane() {
  read -r -e -i "$(tmux display -p '#T' 2>/dev/null)" -p "Pane title: " n
  [[ -n "${n:-}" ]] && tmux select-pane -T "$n"
}

tmux-dashboard() { "$TMUX_WRAPPER_SCRIPTS/dashboard.sh"; }
wtmux() { tm "$@"; }

fix_cursor() {
  if [[ -n "${TMUX:-}" ]]; then
    eval "$(tmux show-environment -s 2>/dev/null | grep -E '^VSCODE_(IPC_HOOK_CLI|GIT_ASKPASS_NODE|GIT_ASKPASS_EXTRA_ARGS|GIT_ASKPASS_MAIN|GIT_IPC_HANDLE)=' || true)"
    if [[ -S "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
      echo "VS Code/Cursor env refreshed from tmux session."
    else
      echo "No valid VSCODE_IPC_HOOK_CLI in this tmux session."
      return 1
    fi
  elif [[ -n "${VSCODE_IPC_HOOK_CLI:-}" ]]; then
    if [[ -S "${VSCODE_IPC_HOOK_CLI}" ]]; then
      echo "VSCODE_IPC_HOOK_CLI already valid in this shell."
    else
      echo "Current VSCODE_IPC_HOOK_CLI is invalid. Open a fresh editor terminal."
      return 1
    fi
  else
    echo "No VSCODE_IPC_HOOK_CLI found. Open a terminal from VS Code/Cursor first."
    return 1
  fi
}

fixvscode() { fix_cursor "$@"; }
