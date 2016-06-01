require 'sinatra/base'
require 'sinatra/json'
require 'json'

class TodoApp < Sinatra::Base
  DB = []

  get "/list" do
    json DB
  end

  post "/list" do
    new_item = JSON.parse request.body.read
    DB.push new_item
    body "ok"
  end
end

# if $0 == __FILE__
if $PROGRAM_NAME == __FILE__
  TodoApp.run!
end
