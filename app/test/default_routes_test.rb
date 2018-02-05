require 'minitest/autorun'
require 'rack/test'
require 'json'
require File.expand_path '../../lib/server', __FILE__
require File.expand_path '../test_helper', __FILE__

class DefaultRoutesTest < MiniTest::Test
  include Rack::Test::Methods
  include TestHelper::Methods

  def app
    Server
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

    response_body = _test_post_json '/reflection', body
    assert_equal body[:greeting], response_body['greeting']
  end
end
