require 'grpc'
require './hello_services_pb'

def main
    stub = Hello::Stub.new('192.168.99.100:30053', :this_channel_is_insecure)
    stub.ping(Content.new(value: "Hello from client")).value
end

puts "Result: #{main}"