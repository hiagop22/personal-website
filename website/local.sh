#!/usr/bin/env bash
set -e

echo "Starting Angular local development..."

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
  echo "Installing dependencies..."
  npm install
fi

echo "Running lint..."
npx ng lint

echo "Running tests..."
npx ng test --watch=false --browsers=ChromeHeadless

echo "Starting Angular dev server..."
npx ng serve
