#!/usr/bin/env bash

cat <<'EOF'
TMUX WRAPPER QUICK REFERENCE

Attach:
  tm / ta          Pick and attach to a session
  tm work          Attach or create session "work"
  tnew NAME        Create detached session

Sessions and windows:
  Prefix + d       Dashboard
  Prefix + Ctrl+f  Session switcher
  Prefix + s       Tree view
  Prefix + C       New named session
  Prefix + $       Rename session
  Prefix + ,       Rename window
  Prefix + P       Rename pane title

Panes:
  Prefix + | / -   Split horizontal / vertical
  Alt + arrows     Move between panes
  Prefix + z       Zoom pane toggle
  Prefix + HJKL    Resize pane

Misc:
  Prefix + r       Reload tmux config
  Prefix + ?       This help
  Prefix + [       Copy mode

Prefix is Ctrl+b
EOF
