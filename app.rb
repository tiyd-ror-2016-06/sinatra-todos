require 'sinatra/base'
require 'sinatra/json'
require 'json'

class TodoApp < Sinatra::Base
  DB = []

  get "/list" do
    json DB
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
end

# if $0 == __FILE__
if $PROGRAM_NAME == __FILE__
  TodoApp.run!
end
