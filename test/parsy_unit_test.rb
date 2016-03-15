require_relative '../lib/web'
require 'stringio'
require 'minitest/autorun'

def first_response_line(socket)
  env = {}
  method, path, http_version = socket.gets.chomp.split(" ")
  env['REQUEST_METHOD'] = method
  env['PATH_INFO'] = path
  env['HTTP_VERSION'] = http_version

  env
end


class ParsyUnitTest < Minitest::Test

  def test_first_response_line
    http = "POST /somepath HTTP/1.1\r\n +
          Location: http://www.google.com/\r\n +
            Content-Type: text/html; charset=UTF-8\r\n" +
            "\r\n"
            socket = StringIO.new http
            env = first_response_line(socket)

            assert_equal "/somepath", env['PATH_INFO']
            assert_equal "POST", env['REQUEST_METHOD']
            assert_equal "HTTP/1.1", env['HTTP_VERSION']

  end

  def test_hash_key_value_parsey
    string = "Host: localhost:9299\r\n" +
      "Connection: keep-alive\r\n" +
      "Content-Length: 17\r\n" +
      "Origin: http://localhost:9299\r\n" +
      "Upgrade-Insecure-Requests: 1\r\n" +
      "Content-Type: application/x-www-form-urlencoded\r\n" +
      "\r\n"

    socket = StringIO.new string
    env = {}

    loop do
      key, value = socket.gets.chomp.split(": ")
      break unless key
      key = key.upcase.tr("-", "_")
      key = "HTTP_#{key}" unless key == 'CONTENT_TYPE' || key == 'CONTENT_LENGTH'
      env[key] = value
    end
      assert_equal "localhost:9299", env["HTTP_HOST"]
      assert_equal "17", env["CONTENT_LENGTH"]
      assert_equal "application/x-www-form-urlencoded", env["CONTENT_TYPE"]
  end
end
