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
  Content-Type: text/html; charset=UTF-8\r\n"
  socket = StringIO.new http
  env = first_response_line(socket)

  assert_equal "/somepath", env['PATH_INFO']
  assert_equal "POST", env['REQUEST_METHOD']
  assert_equal "HTTP/1.1", env['HTTP_VERSION']

  end
end
