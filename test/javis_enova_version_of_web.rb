require 'rack'
require 'socket'

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
			@port = address[:Port]
			@host = address[:Host]
			@app = app
		end

		def start
			@server = TCPServer.new(@port)
      loop do
        client = @server.accept
        puts "Ready for a request, friend!"
        requests = listens_for_requests(client)
        path = getpath(requests[0])
        response_to_request(requests, client, path)
      end
		end

		def stop
			@server && @server.close
		end

    private
    def getpath(request_field)
      return request_field.split(" ")[1]
    end
		def listens_for_requests(client)
			request_lines = []
			while line = client.gets and !line.chomp.empty?
				request_lines << line.chomp
			end
			return request_lines
		end

    def generate_output_from_path(path)
      if path == "/"
        "hello"
      else
        "hello, class ^_^"
      end
    end

		def response_to_request(request_lines, client, path)
			puts "Sending response."
			output = generate_output_from_path(path)
			headers = ["http/1.1 200 ok",
							"date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              "path: #{path}",
							"server: ruby",
              "omg: bbq",
							"content-type: text/html; charset=iso-8859-1",
							"content-length: #{output.length}\r\n\r\n"].join("\r\n")
			client.puts headers
			client.puts output
		end
	end #/Web
end #/Notes

