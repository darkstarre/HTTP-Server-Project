require 'rack'

#Below is the ruby code for setting up a simple rack server
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#================= Steps that Still Need to be Completed =============================
#1. [ done ] define server as server = TCPServer ( :host, :port)
#2. [ done ] TCPServer.accept = socket
#3. [  ]socket.parse  (where parse is our method for parsing the steam, has to be unit tested)
#4. [  ]****** parse will return a hash *******
#5. [  ]****** hash is handed to @app *******
#6. [  ]***** app returns an array of [status, headers, body] *******
#7. [  ]***** socket.print/puts array *********
#8. [  ]***** close the socket **********
#9. [  ]***** next iteration: for multiple request handling, set up a loop *****
#10.[  ]***** ATSOME POINT figure out where/when in code to close server ***********
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
      new(app, address).start
    end

    def stop

    end

    def start
      server = TCPServer.new(@host, @port) #1
      socket = server.accept #2
      #this is where we have to parse what the socket received
      socket.close
    end
  end
end
