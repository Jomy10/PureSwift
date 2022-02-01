#!/usr/bin/ruby

# Building and running the app locally on Debian before publishing to Heroku
# to make sure everything is working on Linux

# Build app
system "docker compose build"

puts "Docker image build."
puts "==="
#  Run app
exec "docker compose up app"
