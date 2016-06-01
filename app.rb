require 'sinatra/base'
require 'sinatra/json'
require 'json'

class TodoApp < Sinatra::Base
  def initialize
    super
    @list = []
  end

  get "/list" do
    json @list
  end

  post "/list" do
    new_item = JSON.parse request.body.read
    @list.push new_item
  end
end

# if $0 == __FILE__
if $PROGRAM_NAME == __FILE__
  TodoApp.run!
end
