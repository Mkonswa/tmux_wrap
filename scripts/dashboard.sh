#!/usr/bin/env bash
# Interactive tmux dashboard for sessions, windows, and panes.

set -uo pipefail

FZF_BIN="${FZF_BIN:-$HOME/.fzf/bin/fzf}"
FZF_TMUX_BIN="${FZF_TMUX_BIN:-$HOME/.fzf/bin/fzf-tmux}"
TMUX_BIN="${TMUX_BIN:-tmux}"

format_lines() {
  "$TMUX_BIN" list-panes -a -F '#{session_name}|#{window_index}|#{window_name}|#{pane_index}|#{pane_title}|#{pane_current_path}|#{pane_id}|#{window_id}|#{session_attached}' \
  | awk -F'|' '{
      attached = ($9 == "1") ? "* " : "  "
      label = sprintf("%s%-14s -> %s:%s -> pane %s", attached, $1, $2, $3, $4)
      if ($5 != "") label = label " [" $5 "]"
      printf "%s|%s|%s|%s|%s|%s|%s\n", label, $6, $7, $8, $1, $2, $4
    }'
}

run_fzf() {
  local opts=(
    --delimiter='|'
    --with-nth=1
    --preview='echo {2}'
    --preview-window='down:1'
    --layout=reverse
    --border=rounded
    --prompt='Dashboard > '
    --header='Enter:jump r:rename-session R:rename-window p:rename-pane x:kill-pane w:kill-window K:kill-session n:new-session N:new-window'
    --expect='r,R,p,x,w,K,n,N'
  )

  if [[ -x "$FZF_BIN" ]]; then
    format_lines | "$FZF_BIN" --height 80% "${opts[@]}"
  elif command -v fzf >/dev/null 2>&1; then
    format_lines | fzf --height 80% "${opts[@]}"
  else
    "$TMUX_BIN" display-message "dashboard: fzf not found"
    return 1
  fi
}

if ! command -v "$TMUX_BIN" >/dev/null 2>&1; then
  echo "tmux not found" >&2
  exit 1
fi

if ! "$TMUX_BIN" list-sessions >/dev/null 2>&1; then
  echo "No tmux server running" >&2
  exit 1
fi

output="$(run_fzf 2>/dev/null)" || true
[[ -z "${output:-}" ]] && exit 0

key="$(printf '%s' "$output" | head -1)"
selection="$(printf '%s' "$output" | tail -1)"
[[ -z "$selection" ]] && exit 0

path="$(printf '%s' "$selection" | cut -d'|' -f2)"
pane_id="$(printf '%s' "$selection" | cut -d'|' -f3)"
win_id="$(printf '%s' "$selection" | cut -d'|' -f4)"
session="$(printf '%s' "$selection" | cut -d'|' -f5)"
win_index="$(printf '%s' "$selection" | cut -d'|' -f6)"

jump() {
  "$TMUX_BIN" switch-client -t "$session" 2>/dev/null || true
  "$TMUX_BIN" select-window -t "${session}:${win_index}" 2>/dev/null || true
  "$TMUX_BIN" select-pane -t "$pane_id" 2>/dev/null || true
}

prompt_value() {
  local label="$1"
  local current="$2"
  local value=""

  if [[ -r /dev/tty ]]; then
    printf "%s [%s]: " "$label" "$current" > /dev/tty
    IFS= read -r value < /dev/tty || true
  fi

  if [[ -z "$value" ]]; then
    value="$current"
  fi

  printf '%s' "$value"
}

case "$key" in
  "")
    jump
    ;;
  r)
    new_session="$(prompt_value "Session name" "$session")"
    [[ -n "$new_session" ]] && "$TMUX_BIN" rename-session -t "$session" "$new_session"
    ;;
  R)
    win_name="$($TMUX_BIN display-message -p -t "$win_id" '#{window_name}' 2>/dev/null || echo "")"
    new_window="$(prompt_value "Window name" "$win_name")"
    [[ -n "$new_window" ]] && "$TMUX_BIN" rename-window -t "$win_id" "$new_window"
    ;;
  p)
    pane_title="$($TMUX_BIN display-message -p -t "$pane_id" '#{pane_title}' 2>/dev/null || echo "")"
    new_title="$(prompt_value "Pane title" "$pane_title")"
    [[ -n "$new_title" ]] && "$TMUX_BIN" select-pane -t "$pane_id" -T "$new_title"
    ;;
  x)
    "$TMUX_BIN" kill-pane -t "$pane_id" 2>/dev/null || true
    ;;
  w)
    "$TMUX_BIN" kill-window -t "$win_id" 2>/dev/null || true
    ;;
  K)
    "$TMUX_BIN" kill-session -t "$session" 2>/dev/null || true
    ;;
  n)
    "$TMUX_BIN" command-prompt -p "New session name:" "new-session -d -s \"%%\" -c \"$HOME\""
    ;;
  N)
    "$TMUX_BIN" command-prompt -I "" -p "New window name:" "new-window -n \"%%\" -c \"$path\""
    ;;
esac
