#!/usr/bin/ruby

require 'fileutils'

# Run this script to build the jql binary.
# Run when jql is updated
# The second `system` call is to build for Linux, if you want to run this
# script, you might want to replace it as it uses a custom Docker image
# that is not present in this repo for building the Linux binary

Dir.chdir("jql") do
    puts "[34mBuilding Mac executable[0m"
    system "cargo build --release --target x86_64-apple-darwin"
    puts "[34mBuilding Linux executable[0m"
    system "docker run --rm -it -v `pwd`:/app rust/linux-aarch64"
end


FileUtils.cp("jql/target/x86_64-apple-darwin/release/jql", "Sources/App/bin/jql_mac")

FileUtils.cp("jql/target/aarch64-unknown-linux-gnu/release/jql", "Sources/App/bin/jql_lin")
