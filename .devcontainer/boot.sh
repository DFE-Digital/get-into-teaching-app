#!/bin/bash

echo "Setting SSH password for vscode user..."
sudo usermod --password $(echo vscode | openssl passwd -1 -stdin) vscode

echo "Updating RubyGems..."
gem update --system

echo "Installing dependencies..."
bundle install
yarn install --ignore-engines

echo "Creating database..."
bin/rails db:create db:schema:load db:migrate db:seed

echo "Done!"
