require 'httparty'
require 'pry'

class MyApi
  attr_reader :headers, :url

  def initialize url
    @url = url
  end

  def login_as username
    @headers = { "Authorization" => username }
  end

  def list_items
    HTTParty.get "#{url}/list",
      headers: headers
  end

  def add_new_item title
    HTTParty.post "#{url}/list",
      body: { title: title }.to_json,
      headers: headers
  end

  def mark_complete title
    HTTParty.patch "#{url}/list",
      query: { title: title },
      headers: headers
  end
end

api = MyApi.new "https://tiy-sinatra-todo.herokuapp.com"
# api = MyApi.new "http://localhost:4567"

puts "Welcome to the TODO manager"
puts "What is your username? > "
# username = gets.chomp
api.login_as "jdabbs"

binding.pry

# puts "Your current todo list"
# api.list_items.each do |item|
#   puts "* #{item}"
# end
#
# puts "What would you like to add?"
# title = gets.chomp
# api.add_new_item title

puts "Done"
