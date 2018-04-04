require 'sinatra'
require 'net/http'

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