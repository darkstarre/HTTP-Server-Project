require_relative '../lib/web'
require 'stringio'
require 'minitest/autorun'



class ParsyUnitTest < Minitest::Test

  def test_first_response_line
    http = "POST /somepath HTTP/1.1\r\n" \
           "Location: http://www.google.com/\r\n" \
           "Content-Type: text/html; charset=UTF-8\r\n" \
           "\r\n"
    socket = StringIO.new http
    env = Notes::Web.parser(socket)

    assert_equal "/somepath", env['PATH_INFO']
    assert_equal "POST", env['REQUEST_METHOD']
    assert_equal "HTTP/1.1", env['HTTP_VERSION']

  end

  def test_hash_key_value_parsey
    string = "Connection: keep-alive\r\n" +
      "Content-Length: 22\r\n" +
      "Origin: http://localhost:9299\r\n" +
      "Upgrade-Insecure-Requests: 1\r\n" +
      "Content-Type: application/x-www-form-urlencoded\r\n" +
      "\r\n" +
      "Good Grief, let it end."
    socket = StringIO.new string
    env = Notes::Web.parser(socket)

    assert_equal "http://localhost:9299", env["HTTP_ORIGIN"]
    assert_equal "22", env["CONTENT_LENGTH"]
    assert_equal "application/x-www-form-urlencoded", env["CONTENT_TYPE"]
    assert_equal "Good Grief, let it end", env["BODY"]

  end
end
