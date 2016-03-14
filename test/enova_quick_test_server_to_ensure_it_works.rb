require_relative 'web'

port = 9292
host = 'localhost'

app = Proc.new do |env_hash|
	path_info = env_hash['PATH_INFO']
	body      = "hello, class ^_^"
	[200, {'Content-Type' => 'text/plain', 'Content-Length' => body.length, 'omg' => 'bbq'}, [body]]
end

server = Notes::Web.new(app, Port: port, Host: 'localhost')
server.start


