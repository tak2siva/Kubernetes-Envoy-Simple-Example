require 'sinatra'
require 'net/http'

require "grpc"
require "./hello_services_pb"

set :bind, '0.0.0.0'
set :port, 4568

$stdout.sync = true

before do
    puts "Val is #{request.env}"
end    

get '/ping' do
    puts "Val is #{request.env['HTTP_X_REQUEST_ID']}"
	"pong from app2 -- #{request.env}"
end

get '/test' do
    puts "Val is #{request.env['HTTP_X_REQUEST_ID']}"
	"result from app2 - 1"
end


############### GRPC Stuff ##############################


class HelloServer < Hello::Service
    def ping content,  _unused_call
        puts "Req body: #{content.value}"
        Content.new(value: "Hello from grpc - app2")
    end
end

def grpc_server
    s = GRPC::RpcServer.new 
    s.add_http2_port('0.0.0.0:50061', :this_port_is_insecure)
    s.handle(HelloServer)
    puts "Starting grpc server in port 50061.."
    s.run_till_terminated
end

Thread.new { grpc_server }