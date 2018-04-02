require 'sinatra'
require 'net/http'

set :bind, '0.0.0.0'
set :port, 4568

get '/ping' do
	'pong from app2'
end

get '/test' do
	"result from app2"
end