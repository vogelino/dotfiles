#!/usr/bin/env bash
# DeepJudge dj2 processes window setup
# Creates 2 vertical panes: Tilt (with storybook) on the left, venv/alembic setup on the right

# Function to wait for shell responsiveness and execute command
tmux_exec() {
  local pane=$1
  local cmd=$2
  local marker="__READY_${RANDOM}__"
  local max_attempts=30

  for attempt in $(seq 1 $max_attempts); do
    tmux send-keys -t "$pane" C-c C-u 2>/dev/null
    sleep 0.1
    tmux send-keys -t "$pane" "echo $marker" C-m
    sleep 0.2

    if tmux capture-pane -p -t "$pane" | grep -q "$marker"; then
      tmux send-keys -t "$pane" "clear" C-m
      sleep 0.1
      if [ -n "$cmd" ]; then
        tmux send-keys -t "$pane" "$cmd" C-m
      fi
      return 0
    fi
    sleep 0.3
  done

  echo "ERROR: Pane $pane not responsive" >&2
  return 1
}

# Create layout: 2 vertical panes side by side
tmux split-window -h

# Wait for panes to initialize
sleep 0.5

# Get pane IDs
pane_ids=($(tmux list-panes -F '#{pane_id}'))

# Pane 1 (left): Tilt (with Tiltfile.local which includes storybook)
tmux_exec "${pane_ids[0]}" "tilt up -f Tiltfile.local --context docker-desktop -- --config-path config/dev-tilt.local.jsonnet"

# Pane 2 (right): venv + alembic setup
tmux_exec "${pane_ids[1]}" "bazel run //:venv .venv && source .venv/bin/activate && pip install -e . && alembic upgrade head && clear"

# Select the right pane
tmux select-pane -t "${pane_ids[1]}"
