require_relative '../lib/notes/server'
require 'stringio'
require 'minitest/autorun'


class ReturnSearchRequestUnitTest < Minitest::Test

  Form_html =
    '<html>
  <head></head>
  <body>
    <h1>Header</h1>
    <fieldset>
      <form action="/search" method="get">
        <label>
          Note
        </label>
        <input type="text" name="query">
        <br>
        <input type="submit">
      </form>
    </fieldset>
  </body>
</html>'

   Notes_html = File.read("lib/notes.html")

  def test_app_on_Path_info_form
    env = {}
    env['PATH_INFO'] = "/form"
    env['HTTP_VERSION'] = "HTTP 1.1"

    assert_equal "HTTP 1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 290\r\n\r\n#{Form_html}\n", Notes::Server.print(env, App.call(env))
  end


  def test_app_on_Path_infor_notes
    env = {}
    env['PATH_INFO'] = "/search"
    env['HTTP_VERSION'] = "HTTP 1.1"

    assert_equal "HTTP 1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 694\r\n\r\n#{Notes_html}", Notes::Server.print(env, App.call(env))

  end
#     string = "Connection: keep-alive\r\n" +
#       "Content-Length: body2.length\r\n" +
#       "Origin: http://localhost:9299\r\n" +
#       "Upgrade-Insecure-Requests: 1\r\n" +
#       "Content-Type: application/x-www-form-urlencoded\r\n" +
#        "\r\n" +
#          "<html><head>

#         <title>WE WIN!!!!</title>

#         </head><body></body></html>"

#     socket = StringIO.new string
#     env = Notes::Web.parser(socket)
#     assert_equal body2, "/search"

#   end
end
