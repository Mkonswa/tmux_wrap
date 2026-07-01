#!/usr/bin/env bash
# Switch between tmux sessions from inside tmux.

set -euo pipefail

TMUX_BIN="${TMUX_BIN:-tmux}"
FZF_TMUX_BIN="${FZF_TMUX_BIN:-$HOME/.fzf/bin/fzf-tmux}"
FZF_BIN="${FZF_BIN:-$HOME/.fzf/bin/fzf}"

lines="$("$TMUX_BIN" list-sessions -F '#{session_name}' 2>/dev/null || true)"
[[ -z "$lines" ]] && exit 0

if [[ -n "${TMUX:-}" ]] && [[ -x "$FZF_TMUX_BIN" ]]; then
  picked="$(printf '%s\n' "$lines" | "$FZF_TMUX_BIN" -p 60%,40% --layout=reverse --border=rounded --prompt='Switch session > ' || true)"
elif [[ -x "$FZF_BIN" ]]; then
  picked="$(printf '%s\n' "$lines" | "$FZF_BIN" --height 40% --layout=reverse --border=rounded --prompt='Switch session > ' || true)"
elif command -v fzf >/dev/null 2>&1; then
  picked="$(printf '%s\n' "$lines" | fzf --height 40% --layout=reverse --border=rounded --prompt='Switch session > ' || true)"
else
  picked="$(printf '%s\n' "$lines" | head -n 1)"
fi

[[ -z "${picked:-}" ]] && exit 0
"$TMUX_BIN" switch-client -t "$picked" 2>/dev/null || true
