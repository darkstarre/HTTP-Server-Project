# require 'rack'
require 'socket'


class Notes
  class Web
    def initialize(app, address)
      @port = address[:Port]
      @host = address[:Host]
      @app = app

      @server = TCPServer.new @host, @port
    end

    def stop
      @server.close
    end

    def start

      loop do
        socket = @server.accept
        env = {}
        method, path, http_version = socket.gets.chomp.split(" ")
        env['PATH_INFO']      = path
        response = @app.call(env)
        status = response[0]
        socket.print "#{http_version} #{status} OK\r\n"
        response[1].each_pair do |key, value|
          socket.print "#{key}: #{value}" + "\r\n"
        end
        body = response[2][0]
        socket.print "\r\n"

        socket.print body
        socket.close
      end
    end
  end
end
