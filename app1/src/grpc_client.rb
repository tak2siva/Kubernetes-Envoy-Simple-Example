require 'grpc'
require './hello_services_pb'

def main
    stub = Hello::Stub.new('localhost:50051', :this_channel_is_insecure)
    stub.ping(Content.new(value: "Hello from client")).value
end

puts "Result: #{main}"