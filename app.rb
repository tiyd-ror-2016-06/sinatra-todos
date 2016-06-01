require 'sinatra/base'
require 'sinatra/json'

class TodoApp < Sinatra::Base
  get "/list" do
    json []
  end
end
