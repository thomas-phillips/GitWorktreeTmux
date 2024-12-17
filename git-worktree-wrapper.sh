#!/bin/bash

REPO_NAME=$(basename $(git rev-parse --show-toplevel))
WORKTREE_DIRECTORY="$HOME/.worktrees/$REPO_NAME"
BRANCH=$1

if [ -z "$BRANCH" ]; then
  echo "Error: Please provide a branch"
  exit 1
fi

git rev-parse --verify $BRANCH >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Error: '$BRANCH' is not a valid branch!"
  exit 1
fi

if ! git worktree list | grep -q "$WORKTREE_DIRECTORY/$BRANCH"; then
  echo "Adding worktree for branch '$BRANCH'..."
  git worktree add "$WORKTREE_DIRECTORY/$BRANCH" "$BRANCH"
else
  echo "Worktree for branch '$BRANCH' already exists."
fi

SESSION="$REPO_NAME/$BRANCH"
FIRST_WINDOW="editor"
SECOND_WINDOW="lazygit"
THIRD_WINDOW="yazi"
FOURTH_WINDOW="commands"

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "Attaching to existing tmux session: $SESSION"
  tmux switch-client -t $SESSION:0
else
  echo "Creating new tmux session: $SESSION"

  if [ ! -d "$WORKTREE_DIRECTORY" ]; then
    echo "Error creating directory: '$1'"
    exit 1
  fi

  tmux new-session -s $SESSION -c $1 -n "editor" -d
  tmux send-keys -t $SESSION:$FIRST_WINDOW "nvim" C-m

  tmux new-window -t $SESSION -n $SECOND_WINDOW
  tmux send-keys -t $SESSION:$SECOND_WINDOW "lazygit" C-m

  tmux new-window -t $SESSION -n $THIRD_WINDOW
  tmux send-keys -t $SESSION:$THIRD_WINDOW "yazi" C-m

  tmux new-window -t $SESSION -n $FOURTH_WINDOW

  tmux switch-client -t $SESSION:$FIRST_WINDOW
fi
