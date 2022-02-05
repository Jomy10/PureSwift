#!/usr/bin/ruby
require 'json'

# Generates the json file for categories an the packages included in them

CategoryContent = Struct.new(:desc, :packages)
categories = JSON.parse(File.read("Public/Data/categories.json"))
packages = JSON.parse(File.read("Public/Data/packages.json"))

packages_in = Hash.new

packages.each do |package|
    package["categories"].each do |category| 
        if not packages_in[category].nil?
            packages_in[category].packages.append(package["title"])
        else
            packages_in[category] = CategoryContent.new(categories[category]["desc"], [package["title"]])
        end
    end
end

new_packages = Hash.new
packages_in.each_with_index do |val|
    new_packages[val[0]] = "{\"desc\":\"#{val[1].desc}\",\"packages\":#{val[1].packages.to_json}}"
end

json = JSON.generate(new_packages).gsub("\\\"", "\"").gsub("\"{", "{").gsub("}\"", "}")

File.write("Public/Data/generated/categories+packages.json", json)