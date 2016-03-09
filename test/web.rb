require 'rack'

#define server as server = TCPServer ( :host, :port)
#TCPServer.accept = socket
#socket.parse  (where parse is our method for parsing the steam, has to be unit tested)
#****** parse will return a hash *******
#****** hash is handed to @app *******
#***** app returns an array of [status, headers, body] *******
#***** socket.print/puts array *********
#***** close the socket **********
#***** next iteration: for multiple request handling, set up a loop *****
#***** ATSOME POINT figure out where/when in code to close server ***********
#
#
#
#***for unit test might need rack.input as a commmand of some sort ****
#*** unit test also needs to use stringerIO to feed string *********c
class Notes
  class Web
    def initialize(app, address)
      @port = address[:port]
      @host = address[:host]
      @app = app
    end

    def stop

    end

    def start

    end
  end
end
