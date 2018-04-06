require 'sinatra'
require "open-uri"
require "faraday"

require "grpc"
require "./hello_services_pb"

set :bind, '0.0.0.0'
set :port, 4567

$stdout.sync = true

TRACE_HEADERS = {
    'X-Request-Id' => "HTTP_X_REQUEST_ID",
    'X-B3-TraceId' => "HTTP_X_B3_TRACEID",
    'X-B3-SpanId' => "HTTP_X_B3_SPANID",
    'X-B3-ParentSpanId' => "HTTP_X_B3_PARENTSPANID",
    'X-B3-Sampled' => "HTTP_X_B3_SAMPLED",
    'X-B3-Flags' => "HTTP_X_B3_FLAGS"
}

before do
    puts "Val is #{request.env['HTTP_X_REQUEST_ID']}"
end    


get '/ping' do
	"pong from app1\n"
end

get '/test' do
	begin
         con = Faraday.new(:url => 'http://localhost:9000')
         TRACE_HEADERS.each { |k,v|
            con.headers[k] = request.env[v]   
         }
         # con.headers['x-request-id'] = request.env['HTTP_X_REQUEST_ID']
         resp = con.get "/app2/test"
         return resp.body
	rescue Exception => e
		return "Exception #{e}"
	end
end



############### GRPC Stuff ##############################

GRPC_HEADERS = ['x-b3-traceid', 'x-b3-spanid', 'x-b3-sampled', 'x-b3-parentspanid', 'x-b3-flags', 'x-request-id']

class HelloServer < Hello::Service
    def ping content,  _unused_call
        puts "Req body: #{content.value}"

        meta = {}
        GRPC_HEADERS.each {|x|
            meta[x] = _unused_call.metadata[x].to_s if _unused_call.metadata[x]
        }

        resp = ""
        puts "headers: #{_unused_call.metadata}\n\n"
        puts "my: #{meta}\n\n"
        # resp = "Meta: #{_unused_call.metadata}\n\n"
        # resp += "My Meta: #{meta}\n\n"

        begin
            stub = Hello::Stub.new('0.0.0.0:9001', :this_channel_is_insecure)
            resp += stub.ping(Content.new(value: "Hello from client"), {metadata: meta}).value
        rescue Exception => e
            resp += e
        end

        Content.new(value: "Hello from grpc - app1 \n Response from app2: #{resp.to_s}")
    end
end

def grpc_server
    s = GRPC::RpcServer.new 
    s.add_http2_port('0.0.0.0:50051', :this_port_is_insecure)
    s.handle(HelloServer)
    puts "Starting grpc server in port 50051.."
    s.run_till_terminated
end

Thread.new { grpc_server }