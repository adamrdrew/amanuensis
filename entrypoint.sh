#!/bin/sh
# If we're on OpenShift, non-root will be a random user
# which will nonetheless be a part of the root group.
if [ "$(id -u)" = "1001" ]; then
  # Ensure $HOME exists and is accessible by the group
  echo "Running on OpenShift as non-root"
  chown $(id -u):$(id -g) $HOME
  echo "$(id -u):x:$(id -u):$(id -g):,,,:${HOME}:/bin/bash" >> /etc/passwd
fi

# Start code-server
exec code-server --bind-addr 0.0.0.0:8080
