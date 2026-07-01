#!/usr/bin/env bash
# Attach to a tmux session from outside tmux.

set -euo pipefail

FZF_BIN="${FZF_BIN:-$HOME/.fzf/bin/fzf}"
TMUX_BIN="${TMUX_BIN:-tmux}"
SESSION_NAME="${1:-}"

pick_with_fzf() {
  local input="$1"
  if [[ -x "$FZF_BIN" ]]; then
    printf '%s\n' "$input" | "$FZF_BIN" --height 40% --layout=reverse --border=rounded --prompt='Attach to > ' || true
  elif command -v fzf >/dev/null 2>&1; then
    printf '%s\n' "$input" | fzf --height 40% --layout=reverse --border=rounded --prompt='Attach to > ' || true
  else
    printf '%s\n' "$input" | head -n 1
  fi
}

pass_editor_env() {
  local target_session="$1"
  local var
  for var in VSCODE_IPC_HOOK_CLI VSCODE_GIT_ASKPASS_NODE VSCODE_GIT_ASKPASS_EXTRA_ARGS VSCODE_GIT_ASKPASS_MAIN VSCODE_GIT_IPC_HANDLE PATH DISPLAY; do
    [[ -n "${!var:-}" ]] && "$TMUX_BIN" set-environment -t "$target_session" "$var" "${!var}" 2>/dev/null || true
  done
}

attach_or_create() {
  local name="$1"
  if "$TMUX_BIN" has-session -t "$name" 2>/dev/null; then
    pass_editor_env "$name"
    exec "$TMUX_BIN" attach -t "$name"
  else
    "$TMUX_BIN" new-session -d -s "$name"
    pass_editor_env "$name"
    exec "$TMUX_BIN" attach -t "$name"
  fi
}

if [[ -n "$SESSION_NAME" ]]; then
  attach_or_create "$SESSION_NAME"
fi

if ! "$TMUX_BIN" list-sessions &>/dev/null; then
  attach_or_create "main"
fi

mapfile -t sessions < <("$TMUX_BIN" list-sessions -F '#{session_name}' 2>/dev/null)

if [[ ${#sessions[@]} -eq 1 ]]; then
  attach_or_create "${sessions[0]}"
fi

picked="$(pick_with_fzf "$(printf '%s\n' "${sessions[@]}")")"
[[ -z "${picked:-}" ]] && exit 0
attach_or_create "$picked"
