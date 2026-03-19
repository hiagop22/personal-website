#!/usr/bin/env bash
set -e

echo "Starting Angular local development..."

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts
nvm use --lts

if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

# Ensure Angular CLI exists
if [ ! -f "./node_modules/.bin/ng" ]; then
  echo "Installing Angular CLI locally..."
  npm install --save-dev @angular/cli
fi

echo "Running lint..."
./node_modules/.bin/ng lint

echo "Running tests..."
./node_modules/.bin/ng test --watch=false --browsers=ChromeHeadless

echo "Starting Angular dev server..."
./node_modules/.bin/ng serve