#!/bin/bash

echo "Installing Ruby dependencies..."

# Check if bundler is installed, install if not
if ! command -v bundle &> /dev/null
then
    echo "Bundler not found, installing..."
    gem install bundler
fi

# Install gems
bundle install

echo "Setting up database..."
# Create database if it doesn't exist and run migrations
bin/rails db:create
bin/rails db:migrate

# Seed database if db/seeds.rb exists and has content
if [ -s "db/seeds.rb" ]; then
  echo "Seeding database..."
  bin/rails db:seed
else
  echo "No seed data found in db/seeds.rb, skipping seeding."
fi

echo "Installation complete."