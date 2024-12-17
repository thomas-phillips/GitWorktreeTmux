#!/bin/bash

git worktree add "$@"

if [ -d "$2" ]; then
  echo "$2"
fi
