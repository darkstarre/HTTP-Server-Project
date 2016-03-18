require 'notes/server' # <-- you'll need to make this
require 'net/http'     # this is from the stdlib

class ServerTest < Minitest::Test
	def port
		9292
	end

	def run_server(port, app, &block)
		server = Notes::Server.new(app, Port: port, Host: 'localhost')
		# The thread allows the server to sit and wait for a request,
		# but still return to here so we can send it.
		thread = Thread.new do
			Thread.current.abort_on_exception = true
			server.start
		end
		wait_for thread
		block.call
	ensure
		thread.kill if thread
		server.stop if server
	end

	def wait_for(thread)
		loop do
			break if thread.status == 'sleep' # it is ready for our request
			raise "The iserver finished without waiting for our request" unless thread.status
			Thread.pass
		end
	end

	def test_it_accepts_and_responds_to_a_web_request
		path_info = "this value should be overridden by the app!"
		app = Proc.new do |env_hash|
			path_info = env_hash['PATH_INFO']
			[ 200,
		 {'Content-Type' => 'text/plain', 'Content-Length' => 16, 'omg' => 'bbq'},
		 ["hello, class ^_^"]
			]
		end
		run_server port, app do
			response = Net::HTTP.get_response('localhost', '/lolol', port)
			assert_equal "200",              response.code
			assert_equal 'bbq',              response.header['omg']
			assert_equal "hello, class ^_^", response.body
			assert_equal "/lolol",           path_info
		end
	end

	def test_it_handles_multiple_requests
		app = Proc.new { |env_hash| [200, {'Content-Type' => 'text/plain'}, []] }
		run_server port, app do
			assert_equal "200", Net::HTTP.get_response('localhost', '/', port).code
			assert_equal "200", Net::HTTP.get_response('localhost', '/', port).code
		end
	end

	def test_it_starts_on_the_specified_port
		other_port = 9293
		app = Proc.new do |env_hash|
			[ 200,
		 {'Content-Type' => 'text/plain', 'Content-Length' => 5},
		 ['hello']
			]
		end
		run_server other_port, app do
			assert_equal 'hello', Net::HTTP.get_response('localhost', '/', other_port).body
		end
	end
end
