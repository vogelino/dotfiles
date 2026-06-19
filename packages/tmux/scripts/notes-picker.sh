#!/usr/bin/env bash
NOTES_DIR="$HOME/notes"
mkdir -p "$NOTES_DIR"

ENTRIES="[+] New note...\t\n"
while IFS= read -r -d '' file; do
  H1=$(grep -m1 "^# " "$file" 2>/dev/null | sed 's/^# //')
  DISPLAY="${H1:-$(basename "$file" .md)}"
  ENTRIES="${ENTRIES}${DISPLAY}\t${file}\n"
done < <(find "$NOTES_DIR" -maxdepth 1 -name "*.md" -print0 2>/dev/null | sort -z)

SELECTED=$(printf "%b" "$ENTRIES" | fzf \
  --delimiter=$'\t' --with-nth=1 \
  --prompt="Note: " --reverse \
  --header="Enter: open  Ctrl-C: cancel")

[ -z "$SELECTED" ] && exit 0

DISPLAY=$(printf "%s" "$SELECTED" | cut -f1)

if [ "$DISPLAY" = "[+] New note..." ]; then
  # Auto-assign a timestamped filename; user renames it by typing over the H1
  SLUG="new-note-$(date +%Y%m%d-%H%M%S)"
  NOTE_FILE="$NOTES_DIR/${SLUG}.md"
  printf "# New Note\n\n" > "$NOTE_FILE"

  tmux set-environment @notes_last_file "$NOTE_FILE"

  STORED_IDS=$(tmux show-environment @notes_pane_ids 2>/dev/null | grep -v '^-' | cut -d= -f2)
  OPEN=0
  for pid in $STORED_IDS; do
    tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" && OPEN=1 && break
  done

  if [ "$OPEN" -eq 1 ]; then
    # Sidebar already open: switch to new file then select title.
    # Sequential Ex commands run in order — no sleep needed.
    for pid in $STORED_IDS; do
      tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" || continue
      tmux send-keys -t "$pid" Escape 2>/dev/null
      tmux send-keys -t "$pid" ":e $NOTE_FILE" Enter 2>/dev/null
      tmux send-keys -t "$pid" ":normal! ggWvg_" Enter 2>/dev/null
    done
  else
    # Sidebar closed: signal toggle to open with visual-select instead of startinsert
    tmux set-environment @notes_new_note 1
    ~/.dotfiles/packages/tmux/scripts/notes-toggle.sh
  fi
  exit 0
else
  NOTE_FILE=$(printf "%s" "$SELECTED" | cut -f2)
fi

tmux set-environment @notes_last_file "$NOTE_FILE"

# If sidebar is open, switch every notes pane to the selected file
STORED_IDS=$(tmux show-environment @notes_pane_ids 2>/dev/null | grep -v '^-' | cut -d= -f2)
OPEN=0
for pid in $STORED_IDS; do
  tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" && OPEN=1 && break
done

if [ "$OPEN" -eq 1 ]; then
  for pid in $STORED_IDS; do
    tmux list-panes -a -F '#{pane_id}' 2>/dev/null | grep -qxF "$pid" || continue
    tmux send-keys -t "$pid" Escape 2>/dev/null
    tmux send-keys -t "$pid" ":e $NOTE_FILE | startinsert" Enter 2>/dev/null
  done
else
  ~/.dotfiles/packages/tmux/scripts/notes-toggle.sh
fi
