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
        # method, path, http_version = socket.gets.chomp.split(" ")
        # env['PATH_INFO']      = path
        env = first_response_line(socket)
        response = @app.call(env)
        status = response[0]
        socket.print "#{env['HTTP_VERSION']} #{status} OK\r\n"
        response[1].each_pair do |key, value|
          socket.print "#{key}: #{value}" + "\r\n"
        end
        body = response[2][0]
        socket.print "\r\n"

        socket.print body
        socket.close
      end
    end


    def first_response_line(socket)
      env = {}
      method, path, http_version = socket.gets.chomp.split(" ")
      env['REQUEST_METHOD'] = method
      env['PATH_INFO'] = path
      env['HTTP_VERSION'] = http_version
      env
    end
  end
end
