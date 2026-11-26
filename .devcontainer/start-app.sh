#!/bin/bash
# Launched automatically by the "Start Get Into Teaching" VS Code task when the
# folder opens. It waits until the container has finished provisioning (boot.sh
# writes the ready marker) and then starts the app with bin/dev.
set -uo pipefail

if [ "${IN_DEVCONTAINER:-}" != "true" ]; then
  echo "Not in a dev container — run bin/dev manually to start the app."
  exit 0
fi

READY_MARKER="${HOME}/.devcontainer-ready"

if [ ! -f "${READY_MARKER}" ]; then
  echo "Waiting for the dev container to finish setting up"
  echo "(installing gems, JavaScript packages and the database)..."
  echo "This only takes a while the first time; the app opens automatically when ready."
  for _ in $(seq 1 900); do
    [ -f "${READY_MARKER}" ] && break
    sleep 1
  done
fi

if [ ! -f "${READY_MARKER}" ]; then
  echo "Setup hasn't finished yet. Check the setup terminal for errors, then run bin/dev."
  exit 1
fi

# Don't start a second server if one is already listening on port 3000.
if (exec 3<>/dev/tcp/127.0.0.1/3000) 2>/dev/null; then
  exec 3>&- 3<&-
  echo "The app is already running on http://localhost:3000"
  exit 0
fi

echo "Starting the app (Rails, assets and background worker)..."
exec bin/dev
