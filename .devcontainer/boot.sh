#!/bin/bash
# Provisions the dev container after it is created.
# This runs once (postCreateCommand). It is idempotent, so re-running is safe.
set -euo pipefail

# The auto-start task waits for this marker before launching the app, so the
# server never starts before gems/JS/the database are ready. Clear it now and
# recreate it once setup succeeds below.
READY_MARKER="${HOME}/.devcontainer-ready"
rm -f "${READY_MARKER}"

echo "== Setting SSH password for the vscode user =="
# Used by the sshd feature; harmless if SSH is unused.
echo "vscode:vscode" | sudo chpasswd

echo "== Installing the Bundler version from Gemfile.lock =="
# The Ruby install ships an older default Bundler than the lockfile's
# "BUNDLED WITH" version. Installing the exact version up front avoids the
# "installing Bundler X and restarting" dance in bin/setup and the Bundler
# errors that crash the Ruby LSP on first launch.
BUNDLER_VERSION="$(grep -A1 'BUNDLED WITH' Gemfile.lock | tail -n1 | tr -d '[:space:]')"
if [ -n "${BUNDLER_VERSION}" ]; then
  gem install bundler -v "${BUNDLER_VERSION}" --no-document
fi

echo "== Setting up the application (gems, JS, database) =="
# Reuse the same setup script developers run on their own machines so the
# container matches local development. --skip-server means we install and
# prepare everything but don't start the web server here; the server is
# started automatically by the "Start Get Into Teaching" VS Code task.
bin/setup --skip-server

touch "${READY_MARKER}"

echo "== Done! The app will start automatically and open on port 3000. =="
