#!/usr/bin/env bash
# DeepJudge dj2 processes window setup
# Creates a 2x2 grid with 4 panes for monitoring different processes

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

# Create the 2x2 pane layout (top 30%, bottom 70%)
tmux split-window -v -p 70
tmux split-window -h
tmux select-pane -U
tmux split-window -h

# Wait for panes to initialize
sleep 0.5

# Get pane IDs
pane_ids=($(tmux list-panes -F '#{pane_id}'))

# Execute commands in each pane
# Customize these commands for your needs:

# Pane 1 (top-left): Tilt
tmux_exec "${pane_ids[0]}" "tilt up --context docker-desktop -- --config-path config/dev-tilt.local.jsonnet"

# Pane 2 (top-right): Logs or monitoring
tmux_exec "${pane_ids[1]}" "pnpm install && cd web/search && pnpm run storybook"

# Pane 3 (bottom-left): Database or other service
tmux_exec "${pane_ids[2]}" "bazel run //:venv .venv && source .venv/bin/activate && pip install -e . && alembic upgrade head && clear"

# Pane 4 (bottom-right): General terminal
tmux_exec "${pane_ids[3]}" "cd web/search && clear"

# Select the first pane
tmux select-pane -t "${pane_ids[2]}"
