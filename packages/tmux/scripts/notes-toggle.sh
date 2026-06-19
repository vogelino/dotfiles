#!/usr/bin/env bash
NOTES_DIR="$HOME/notes"
mkdir -p "$NOTES_DIR"
SESSION=$(tmux display-message -p '#S')

# State: space-separated list of notes pane IDs stored in the session env.
# We verify existence rather than trusting title (nvim overwrites it at startup).
STORED_IDS=$(tmux show-environment @notes_pane_ids 2>/dev/null | grep -v '^-' | cut -d= -f2)

# Check if at least one stored pane still exists
notes_are_open() {
  [ -z "$STORED_IDS" ] && return 1
  for pid in $STORED_IDS; do
    tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" && return 0
  done
  return 1
}

if notes_are_open; then
  # ── Close ────────────────────────────────────────────────────────────────
  WIN_IDS=$(tmux list-windows -t "$SESSION" -F '#{window_id}' 2>/dev/null | tr '\n' ' ')

  # Save current width as a percentage before the panes disappear
  for pid in $STORED_IDS; do
    tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" || continue
    PANE_W=$(tmux display-message -t "$pid" -p '#{pane_width}' 2>/dev/null)
    WIN_W=$(tmux display-message -t "$pid" -p '#{window_width}' 2>/dev/null)
    if [ -n "$PANE_W" ] && [ -n "$WIN_W" ] && [ "$WIN_W" -gt 0 ]; then
      tmux set-environment @notes_pane_width_pct $(( PANE_W * 100 / WIN_W ))
    fi
    break
  done

  # Clear state BEFORE sending quit so VimLeave hooks don't redundantly close
  tmux set-environment @notes_pane_ids ""

  for pid in $STORED_IDS; do
    CMD=$(tmux display-message -t "$pid" -p '#{pane_current_command}' 2>/dev/null | tr -d '[:space:]')
    if [ "$CMD" = "nvim" ]; then
      tmux send-keys -t "$pid" Escape    2>/dev/null
      tmux send-keys -t "$pid" ":wqa" Enter 2>/dev/null
    else
      tmux kill-pane -t "$pid" 2>/dev/null
    fi
  done

  # Rebalance remaining panes once nvim has had time to exit
  (sleep 0.3
   for win_id in $WIN_IDS; do
     tmux select-layout -t "$win_id" -E 2>/dev/null
   done
  ) &

else
  # ── Open ─────────────────────────────────────────────────────────────────
  # New notes (created by picker) want visual-select; existing notes want insert mode
  NEW_NOTE=$(tmux show-environment @notes_new_note 2>/dev/null | grep -v '^-' | cut -d= -f2)
  tmux set-environment @notes_new_note ""

  LAST_NOTE=$(tmux show-environment @notes_last_file 2>/dev/null | grep -v '^-' | cut -d= -f2)
  if [ -z "$LAST_NOTE" ] || [ ! -f "$LAST_NOTE" ]; then
    LAST_NOTE="$NOTES_DIR/note.md"
    touch "$LAST_NOTE"
    tmux set-environment @notes_last_file "$LAST_NOTE"
  fi

  # NVIM_IS_NOTES_PANE is read in polish.lua at module load (before BufEnter fires).
  # NVIM_NOTES_SELECT triggers VimEnter to visual-select the title (after all plugins load).
  if [ "$NEW_NOTE" = "1" ]; then
    PANE_CMD="NVIM_IS_NOTES_PANE=1 NVIM_NOTES_SELECT=1 nvim -n -c 'set showtabline=0 laststatus=0' '$LAST_NOTE'"
  else
    PANE_CMD="NVIM_IS_NOTES_PANE=1 nvim -n -c 'set showtabline=0 laststatus=0' -c 'startinsert' '$LAST_NOTE'"
  fi

  # Restore last-used width percentage; default to 35% on first open
  PCT=$(tmux show-environment @notes_pane_width_pct 2>/dev/null | grep -v '^-' | cut -d= -f2)
  [ -z "$PCT" ] && PCT=35

  CURRENT_WIN=$(tmux display-message -p '#{window_id}')
  NEW_IDS=""

  while IFS= read -r win_id; do
    if [ "$win_id" = "$CURRENT_WIN" ]; then
      PANE_ID=$(tmux split-window -t "$win_id" -h -f -l "${PCT}%" -P -F '#{pane_id}' \
                  "$PANE_CMD" 2>/dev/null)
    else
      PANE_ID=$(tmux split-window -t "$win_id" -h -f -l "${PCT}%" -d -P -F '#{pane_id}' \
                  "$PANE_CMD" 2>/dev/null)
    fi
    [ -n "$PANE_ID" ] && NEW_IDS="$NEW_IDS $PANE_ID"
  done < <(tmux list-windows -t "$SESSION" -F '#{window_id}')

  tmux set-environment @notes_pane_ids "${NEW_IDS# }"
fi
