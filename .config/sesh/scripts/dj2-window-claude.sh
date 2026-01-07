#!/usr/bin/env bash
# DeepJudge dj2 processes window setup
# Creates a 2x2 grid with 4 panes for monitoring different processes

WINDOW_NAME="CLAUDE"

# Function to wait for shell responsiveness and execute command
tmux_exec() {
  local pane=$1
  local cmd=$2
  local marker="__READY_${RANDOM}__"
  local max_attempts=30

  for attempt in $(seq 1 $max_attempts); do
    tmux send-keys -t "$WINDOW_NAME.$pane" C-c C-u 2>/dev/null
    sleep 0.1
    tmux send-keys -t "$WINDOW_NAME.$pane" "echo $marker" C-m
    sleep 0.2

    if tmux capture-pane -p -t "$WINDOW_NAME.$pane" | grep -q "$marker"; then
      tmux send-keys -t "$WINDOW_NAME.$pane" "clear" C-m
      sleep 0.1
      if [ -n "$cmd" ]; then
        tmux send-keys -t "$WINDOW_NAME.$pane" "$cmd" C-m
      fi
      return 0
    fi
    sleep 0.3
  done

  echo "ERROR: Pane $pane not responsive" >&2
  return 1
}

# Create a vertical split (top 30%, bottom 70%) in the CLAUDE window
tmux split-window -t "$WINDOW_NAME" -h

# Wait for panes to initialize
sleep 0.5

# Get pane IDs for the CLAUDE window
pane_ids=($(tmux list-panes -t "$WINDOW_NAME" -F '#{pane_id}'))

# Execute commands in each pane
# Customize these commands for your needs:

# Pane 1 (left): Tilt
tmux_exec "${pane_ids[0]}" "claude"

# Pane 2 (right): Commands
tmux_exec "${pane_ids[1]}" "clear"

# Select the first pane (without focusing the window)
tmux select-pane -t "$WINDOW_NAME.${pane_ids[0]}"
