#!/bin/bash

echo "Installing Ruby dependencies..."

# Removed 'sudo' from bundle install. Using 'sudo' can lead to gems being installed
# in system-wide paths that are not accessible to the non-root user running the
# Rails server, causing 'command not found' errors for executables like bin/rails.
# It's best practice to install gems as the user who will run the application.
bundle install

# Clean up unused gems to keep the bundle lean and reduce image size in production.
bundle clean --force

echo "Installation complete."