#!/usr/bin/env bash
# Called from nvim's VimLeave when the notes sidebar exits naturally (not via toggle).
# Closes all other notes panes across all windows and rebalances layouts.

CURRENT_PANE=$(tmux display-message -p '#{pane_id}')
STORED_IDS=$(tmux show-environment @notes_pane_ids 2>/dev/null | grep -v '^-' | cut -d= -f2)
[ -z "$STORED_IDS" ] && exit 0

SESSION=$(tmux display-message -p '#S')
WIN_IDS=$(tmux list-windows -t "$SESSION" -F '#{window_id}' 2>/dev/null | tr '\n' ' ')

# Save the closing pane's width as a percentage before it disappears
PANE_W=$(tmux display-message -t "$CURRENT_PANE" -p '#{pane_width}' 2>/dev/null)
WIN_W=$(tmux display-message -t "$CURRENT_PANE" -p '#{window_width}' 2>/dev/null)
if [ -n "$PANE_W" ] && [ -n "$WIN_W" ] && [ "$WIN_W" -gt 0 ]; then
  tmux set-environment @notes_pane_width_pct $(( PANE_W * 100 / WIN_W ))
fi

# Clear state BEFORE sending quit to prevent other panes' VimLeave from looping
tmux set-environment @notes_pane_ids ""

for pid in $STORED_IDS; do
  [ "$pid" = "$CURRENT_PANE" ] && continue
  tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" || continue
  CMD=$(tmux display-message -t "$pid" -p '#{pane_current_command}' 2>/dev/null | tr -d '[:space:]')
  if [ "$CMD" = "nvim" ]; then
    tmux send-keys -t "$pid" Escape 2>/dev/null
    tmux send-keys -t "$pid" ":qa!" Enter 2>/dev/null
  else
    tmux kill-pane -t "$pid" 2>/dev/null
  fi
done

(sleep 0.3
 for win_id in $WIN_IDS; do
   tmux select-layout -t "$win_id" -E 2>/dev/null
 done) &
