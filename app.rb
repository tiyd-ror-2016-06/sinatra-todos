require 'sinatra/base'
require 'sinatra/json'
require 'json'

AdminUsername = ENV["ADMIN_USERNAME"] || File.read("./secret.txt").chomp

class TodoApp < Sinatra::Base
  set :logging, true
  set :show_exceptions, false
  error do |e|
    binding.pry
    raise e
  end

  DB = { "secret_stuff" => "yes" }

  before do
    require_authorization!
  end

  get "/db" do
    if admin?
      json DB
    else
      status 403
      body "No!"
    end
  end

  get "/list" do
    DB[username] ||= []
    json DB[username]
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
      DB[username] ||= []
      DB[username].push new_item
      body "ok"
    else
      status 422
      body "No title"
    end
  end

  patch "/list" do
    title = params[:title]
    DB[username] ||= []
    existing_item = DB[username].find { |i| i["title"] == title }
    if existing_item
      DB[username].delete existing_item
      status 200
    else
      status 404
    end
  end

  def require_authorization!
    unless username
      status 401
      halt({ error: "You must log in" }.to_json)
    end
  end

  def username
    request.env["HTTP_AUTHORIZATION"]
  end

  def admin?
    username == AdminUsername
  end
end

# if $0 == __FILE__
if $PROGRAM_NAME == __FILE__
  TodoApp.run!
end
