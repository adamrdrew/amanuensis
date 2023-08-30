#!/bin/bash

# Explicitly set the HOME directory
export HOME=/home/coder

# Add current user to /etc/passwd
if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-coder}:x:$(id -u):0:${USER_NAME:-coder} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Ensure the .config directory is writable
if [ -n "$HOME" ]; then
  mkdir -p "$HOME/.config"
  chown -R $(id -u):0 "$HOME/.config"
fi

# Execute the original command
exec "$@"
