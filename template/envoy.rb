require 'jbuilder'
require 'ostruct'
require 'pry'
require 'json'

env = {
  localhost: '127.0.0.1',
  adminPort: 9901,
  listeners: [{
    name: 'http_listener',
    address: '0.0.0.0',
    portValue: 80,
    filterChains: [
    filters: [{
      operationName: 'ingress',
      generateRequestId: false,
      routeConfig: [{
        name: 'local_route',
        virtualHosts: [{
          virtualHostName: 'app1_http',
          routes: [{
            prefix: '/',
            cluster: 'local_service'
          }]
        }],
      }]
    }]
    ],
    }, {
    name: 'grpc_listener',
    address: '0.0.0.0',
    portValue: 50052,
    filters: [{
      operationName: 'ingress',
      generateRequestId: false,
      routeConfig: [{
        name: 'local_grpc',
        virtualHosts: [{
          virtualHostName: 'app1_grpc',
          routes: [{
            prefix: '/',
            cluster: 'local_grpc'
          }]
        }],
      }]
    }]
  },
    {
    name: 'outbound_listener',
    address: '0.0.0.0',
    portValue: 9000,
    filters: [{
      operationName: 'egress',
      generateRequestId: false,
      routeConfig: [{
        name: 'local_outbound',
        virtualHosts: [{
          virtualHostName: 'app1_out',
          routes: [{
            prefix: '/app2',
            prefixRewrite: '/',
            cluster: 'app2'
          }]
        }],
      }]
    }]
  }
  ],
  clusters: [{
    name: 'local_service',
    hosts: [{
      address: '127.0.0.1',
      portValue: 4567
    }]
  }, {
    name: 'local_grpc',
    hosts: [{
      address: '127.0.0.1',
      portValue: 50051
    }]
  }, {
    name: 'app2',
    hosts: [{
      address: 'app2',
      portValue: 80
    }]
  }, {
    name: 'zipkin',
    hosts: [{
      address: 'zipkin',
      portValue: 9411
    }]
  }]
}
# config = OpenStruct.new env
config = JSON.parse(env.to_json, object_class: OpenStruct)

res = Jbuilder.encode do |json|
  json.admin do
    json.access_log_path '/tmp/admin_access.log'
    json.address do
      json.socket_address do
        json.address config.localhost
        json.port_value config.adminPort
      end
    end
  end
  
  json.tracing do
    json.http do
      json.name  'envoy.zipkin'
      json.config do
        json.collector_cluster 'zipkin'
        json.collector_endpoint '/api/v1/spans'
      end
    end
  end
  
  json.static_resources do
    json.listeners config.listeners do |listener|
      json.name listener.name
      json.address do
        json.socket_address do
          json.address listener.address
          json.port_value listener.portValue
        end
      end
      json.filter_chains listener.filters do |filter|
        json.filters do
          json.name 'envoy.http_connection_manager'
          json.config do
            json.stat_prefix 'ingress_http'
            json.generate_request_id filter.generateRequestId
            json.codec_type 'AUTO'
            json.tracing do
              json.operation_name filter.operationName
            end

            json.route_config filter.routeConfig do |routeConfig|
              json.name routeConfig.name
              json.virtual_hosts routeConfig.virtualHosts do |vh|
                json.name vh.virtualHostName
                json.domains ["*"]
                json.routes vh.routes do |route|
                  json.match do
                    json.prefix route.prefix
                  end
                  json.route do
                    json.cluster route.cluster
                    json.prefix_rewrite route.prefixRewrite
                  end
                end
              end
            end

            json.http_filters do
              json.name "envoy.router"
            end
          end
        end
      end
    end
    json.clusters config.clusters do |cluster|
      json.name cluster.name
      json.connect_timeout '0.25s'
      json.type 'strict_dns'
      json.lb_policy 'ROUND_ROBIN'
      json.hosts cluster.hosts do |host|
        json.socket_address do
          json.address host.address
          json.port_value host.portValue
        end
      end
    end
  end
end

puts res