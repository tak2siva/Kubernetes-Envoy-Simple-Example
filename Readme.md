### Installation

Install minikube on your machine

### Setup

```
helm upgrade --install front-envoy helm/front-envoy-chart
helm upgrade --install app1 helm/app1-chart
helm upgrade --install app2 helm/app2-chart
```
## Req Tracing
#### HTTP

Get node IP by
```
minikube ip
```

Hit
```
http://NODE_IP:30080/app/1/ping
pong from app1
```

app1 commuincate with app2
```
http://NODE_IP:30080/app/1/test
result from app2 - 1
```

Now the corresponding logs can be seen in zipkin
```
http://192.168.99.100:30011/
```

#### Grpc

Install grpc ruby tools

```
    gem install grpc
    gem install grpc-tools
```

Change dir
```
cd client/src/
```

Change the ip address to match your NODE_IP in `grpc_client.rb`

```
ruby grpc_client.rb
```
```
Result: Hello from grpc - app1
 Response from app2: Hello from grpc - app2
```