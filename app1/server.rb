require 'sinatra'
require 'net/http'

set :bind, '0.0.0.0'
set :port, 4567

get '/ping' do
	'pong from app1'
end

get '/test' do
	url = URI.parse('http://app2:4568/test')
	req = Net::HTTP::Get.new(url.to_s)
	begin
		res = Net::HTTP.start(url.host, url.port) {|http|
	  		http.request(req)
		}
		return res.body
	rescue Exception => e
		return "Exception #{e}"
	end
end