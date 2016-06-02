require 'httparty'
require 'pry'

Url = "https://tiy-sinatra-todo.herokuapp.com"

puts "Welcome to the TODO manager"
puts "What is your username? > "
# username = gets.chomp
username = "jdabbs"

r = HTTParty.get "#{Url}/list",
  headers: { "Authorization" => username }

puts "Your current todo list"
r.each do |item|
  puts "* #{item}"
end

puts "What would you like to add?"
title = gets.chomp
r = HTTParty.post "#{Url}/list",
  body: { title: title }.to_json,
  headers: { "Authorization" => username }

puts "Done"
