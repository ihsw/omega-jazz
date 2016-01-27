require_relative './test_helper'
require_relative '../lib/server'
require 'rack/test'
require 'json'

class ServerTest < MiniTest::Test
  include Rack::Test::Methods

  def app
    Server
  end

  def _test_json (url, body)
    post url, body

    status = last_response.status
    error = last_response.errors.split("\n").first
    assert last_response.ok?, "Message was not 200 OK: #{status}\n#{error}"

    JSON.parse last_response.body
  end

  def _create_post(body, cb)
    response_body = _test_json '/posts', body.to_json
    assert response_body['id'].is_a? Numeric
    cb.call response_body
  end

  def test_hello_world
    get '/'
    assert last_response.ok?
    assert_equal 'Hello, world!', last_response.body
  end

  def test_ping
    get '/ping'
    assert last_response.ok?
    assert_equal 'Pong', last_response.body
  end

  def test_reflection
    body = { greeting: 'Hello, world!' }

    response_body = _test_json '/reflection', body.to_json
    assert_equal body[:greeting], response_body['greeting']
  end

  def test_post_create
    body = { body: 'Hello, world!' }
    _create_post body, proc { |response_body| }
  end

  def test_post_get
    body = { body: 'Hello, world!' }
    _create_post body, proc { |create_response_body|
      id = create_response_body['id']
      get "/post/#{id}"

      assert last_response.ok?

      get_response_body = JSON.parse last_response.body

      assert_equal create_response_body['body'], get_response_body['body']
    }
  end
end
