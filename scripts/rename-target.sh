#!/usr/bin/env bash
# Interactive rename for session, window, or pane.

set -euo pipefail

pane_id="${1:-}"
[[ -z "$pane_id" ]] && exit 0

session="$(tmux display -p -t "$pane_id" '#{session_name}')"
window="$(tmux display -p -t "$pane_id" '#{window_index}')"
pane_title="$(tmux display -p -t "$pane_id" '#{pane_title}')"
window_name="$(tmux display -p -t "$pane_id" '#{window_name}')"

echo ""
echo "Rename target in session: $session"
echo "[1] Session  [2] Window  [3] Pane title"
read -r -p "Choice [1-3]: " choice

case "$choice" in
  1)
    read -r -e -i "$session" -p "New session name: " new_name
    [[ -n "${new_name:-}" ]] && tmux rename-session -t "$session" "$new_name"
    ;;
  2)
    read -r -e -i "$window_name" -p "New window name: " new_name
    [[ -n "${new_name:-}" ]] && tmux rename-window -t "${session}:${window}" "$new_name"
    ;;
  3)
    read -r -e -i "$pane_title" -p "New pane title: " new_name
    [[ -n "${new_name:-}" ]] && tmux select-pane -t "$pane_id" -T "$new_name"
    ;;
esac
