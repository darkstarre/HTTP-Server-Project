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
        env = Notes::Web.parser(socket)
        first_line, head, body = @app.call(env)
        socket.print "#{env['HTTP_VERSION']} #{first_line} OK\r\n"
        head.each_pair do |key, value|
          socket.print "#{key}: #{value}" + "\r\n"
        end
        socket.print "\r\n"

        body = body[0]
        socket.print body
        socket.close
      end
    end

    def self.parser(socket)
      env = {}
      method, path, http_version = socket.gets.chomp.split(" ")
      env['REQUEST_METHOD'] = method
      env['PATH_INFO'] = path
      env['HTTP_VERSION'] = http_version
      loop do
        key, value = socket.gets.chomp.split(": ")
        break unless key
        key = key.upcase.tr("-", "_")
        key = "HTTP_#{key}" unless key == 'CONTENT_TYPE' || key == 'CONTENT_LENGTH'
        env[key] = value
      end
      body = socket.read(env["CONTENT_LENGTH"].to_i)
      env["BODY"] = body
      env
    end

    def router
      if path == "/form"
        body = File.read("form.html")
        status = "200"
        socket.print "#{http_version} #{status} OK\r\n"
        socket.print "Content-Type: text/html\r\n"
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
    end
  end
end

server = Notes::Web.new({port: "3000", host: "localhost"})
server.start
