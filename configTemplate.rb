require 'json'

res = File.read 'app1/sidecar-envoy.json'
File.write 'helm/app1-chart/envoy.json', res.strip.gsub("\n",'')

res = File.read 'app2/sidecar-envoy.json'
File.write 'helm/app2-chart/envoy.json', res.strip.gsub("\n",'')

res = File.read 'front_envoy/front-envoy.json'
File.write 'helm/front-envoy-chart/envoy.json', res.strip.gsub("\n",'')