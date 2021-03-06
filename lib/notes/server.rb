require 'socket'


class Notes
  class Server
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
        env = Notes::Server.parser(socket)
        response = @app.call(env)
        try = Notes::Server.print(env, response)
        socket.print try
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

    def self.print(env, response)
      body = response[2].join
      string = "#{env['HTTP_VERSION']} #{response[0]} OK\r\n" +

        response[1].map{|k,v| "#{k}: #{v}"}.join("\r\n") + "\r\n" +
        "\r\n" + body
        string #Test to see if I need this!

        # elsif env['PATH_INFO'].start_with? "/search"
        # 	path, parameters = path.split("?")
        # 	parameters.split("&").each do |params|
        # 		key, value = params.split("=")
        # 		socket.print "#{key} has the value #{value}"
        # 	end

    end
  end
end

def pathway(html_file)
   body = File.read("lib/form_http_css/#{html_file}")
end

App = Proc.new do |env|
 if env['PATH_INFO'] == "/form"
   body = pathway "user_input_form.html"
   ["200", {'Content-Type' => 'text/html', 'Content-Length' => body.length}, [body]]
 elsif env['PATH_INFO'].start_with? "/search"
   body = pathway "notes.html"
   ["200", {'Content-Type' => 'text/html', 'Content-Length' => body.length}, [body]]
 else
   body = "Not found"
   ["404", {'Content-Type' => 'text/html', 'Content-Length' => body.length}, [body]]
 end

end

