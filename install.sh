#!/bin/bash

NAME=$1

if [ ! -n "${HOME}" ]; then
  echo "Error: 'HOME' environment variable not set!"
  exit 1
fi

TARGET_DIRECTORY="$HOME/.bin"
TARGET_FILE="$(pwd)/git-worktree-wrapper.sh"

echo "'$TARGET_DIRECTORY' does not exist... creating directory."
if [ ! -d "$TARGET_DIRECTORY" ]; then
  mkdir "$TARGET_DIRECTORY"
fi

if ! printenv PATH | grep "\.bin"; then
  echo "Path not set to '$TARGET_DIRECTORY'."

  PATH_APPEND="export PATH=\$PATH:\$HOME/.bin"
  CURRENT_SHELL=$(basename ${SHELL})

  echo "Adding '$TARGET_DIRECTORY' to PATH in '$CURRENT_SHELL'."

  case $CURRENT_SHELL in
    zsh)
      echo "$PATH_APPEND" >> ~/.zshrc
      ;;

    *)
      echo "unknown or not implemented - '$CURRENT_SHELL'."
      ;;
  esac

  echo "Please source shell file."
fi

echo "Linking '$TARGET_FILE' to '$TARGET_DIRECTORY/$NAME'."
ln -sf "$TARGET_FILE" "$TARGET_DIRECTORY/$NAME"

