require 'sinatra/base'
require 'sinatra/json'
require 'json'

class TodoApp < Sinatra::Base
  set :logging, true
  set :show_errors, false
  error do |e|
    binding.pry
  end

  DB = []

  get "/list" do
    username = request.env["HTTP_AUTHORIZATION"]
    if username
      json DB
    else
      status 401
      json error: "You must log in"
    end
  end

  post "/list" do
    body = request.body.read

    begin
      new_item = JSON.parse body
    rescue
      status 400
      halt "Can't parse json: '#{body}'"
    end

    if new_item["title"]
      DB.push new_item
      body "ok"
    else
      status 422
      body "No title"
    end
  end

  patch "/list" do
    title = params[:title]
    existing_item = DB.find { |i| i["title"] == title }
    if existing_item
      DB.delete existing_item
      status 200
    else
      status 404
    end
  end
end

# if $0 == __FILE__
if $PROGRAM_NAME == __FILE__
  TodoApp.run!
end
