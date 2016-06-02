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
    header "Authorization", "jdabbs"
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

  def test_requires_title
    response = post "/list", '{}'
    assert_equal 422, response.status
    assert_equal "No title", response.body
  end

  def test_handles_bad_json
    response = post "/list", 'not json'
    assert_equal 400, response.status
    assert_equal "Can't parse json: 'not json'", response.body
  end

  def test_can_mark_items_complete
    post "/list", '{"title": "groceries"}'
    post "/list", '{"title": "learn ruby"}'

    response = patch "/list", title: "learn ruby"
    assert_equal 200, response.status

    response = get "/list"
    json = JSON.parse response.body
    assert_equal 1, json.count
  end

  focus
  def test_login_is_required
    # don't log in ...
    response = get "/list"
    assert_equal 401, response.status

    body = JSON.parse response.body
    assert_equal "You must log in", body["error"]
  end
end
