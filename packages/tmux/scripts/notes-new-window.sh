#!/usr/bin/env bash
# Runs via after-new-window hook. Adds the sidebar to the new window if it's open.

STORED_IDS=$(tmux show-environment @notes_pane_ids 2>/dev/null | grep -v '^-' | cut -d= -f2)
[ -z "$STORED_IDS" ] && exit 0

# Verify at least one stored pane still exists (notes might have been closed manually)
OPEN=0
for pid in $STORED_IDS; do
  tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" && OPEN=1 && break
done
[ "$OPEN" -eq 0 ] && { tmux set-environment @notes_pane_ids ""; exit 0; }

NOTES_DIR="$HOME/notes"
LAST_NOTE=$(tmux show-environment @notes_last_file 2>/dev/null | grep -v '^-' | cut -d= -f2)
[ -z "$LAST_NOTE" ] || [ ! -f "$LAST_NOTE" ] && LAST_NOTE="$NOTES_DIR/note.md"

PCT=$(cat "$HOME/.local/state/notes-sidebar-width" 2>/dev/null | grep -E '^[0-9]+$')
[ -z "$PCT" ] && PCT=35

PANE_ID=$(tmux split-window -h -f -l "${PCT}%" -d -P -F '#{pane_id}' \
            "nvim --cmd 'let g:is_notes_pane=1' -n -c 'set showtabline=0 laststatus=0' -c 'startinsert' '$LAST_NOTE'" 2>/dev/null)

[ -n "$PANE_ID" ] && tmux set-environment @notes_pane_ids "$STORED_IDS $PANE_ID"
