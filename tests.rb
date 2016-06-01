require 'pry'
require 'minitest/autorun'
require 'minitest/focus'

require 'minitest/reporters'
Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new

require 'rack/test'

require "./app"

class TodoAppTests < Minitest::Test
  include Rack::Test::Methods

  def app
    TodoApp
  end

  def setup
    TodoApp::DB.clear
  end

  def test_starts_with_empty_list
    response = get "/list"

    assert_equal 200, response.status
    assert_equal "[]", response.body
  end

  def test_can_add_to_list
    post "/list", '{"title": "groceries"}'
    post "/list", '{"title": "learn ruby"}'

    response = get "/list"

    assert_equal 200, response.status

    list = JSON.parse response.body
    assert_equal 2, list.count
    assert_equal "groceries", list.first["title"]
  end

  def test_add_response
    response = post "/list", '{"title": "do things"}'
    assert_equal 200, response.status
    assert_equal "ok", response.body
  end
end
