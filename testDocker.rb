#!/usr/bin/ruby

# Building and running the app locally on Debian before publishing to Heroku
# to make sure everything is working on Linux

# Build app
exec "docker compose build"

puts "Docker image build."
sleep 2
#  Run app
exec "docker compose up app"
