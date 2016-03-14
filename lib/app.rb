require 'socket'


class Notes
  class Web
    def initialize(address)
      @port = address[:port]
      @host = address[:host]
      @server = TCPServer.new @host, @port
    end

    def stop
      @server.close
    end

    def start
      loop do
        socket = @server.accept

        method, path, http_version = socket.gets.chomp.split(" ")

        puts "#{method}, #{path}, #{http_version}"

        if path == "/form"
          body = File.read("form.html")
          status = "200"
          socket.print "#{http_version} #{status} OK\r\n"
          socket.print "Content-Type: text/html \r\n"
          socket.print "Content-Length: #{body.length}\r\n"
          socket.print "\r\n"
          socket.print body
        end

        if path.start_with? "/search"
          path, parameters = path.split("?")
          parameters.split("&").each do |params|
            key, value = params.split("=")
            puts "#{key} has the value #{value}"
          end
        end

        socket.close
      end
    end
  end
end

server = Notes::Web.new({port: "3000", host: "localhost"})
server.start
