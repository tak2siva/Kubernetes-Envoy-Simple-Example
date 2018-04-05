FROM ruby:2.5.0-alpine3.7

RUN ruby --version
RUN gem install sinatra
RUN gem install faraday
RUN gem install grpc
RUN gem install grpc-tools
RUN apk add --no-cache --update curl
COPY server.rb ./server.rb
COPY src src
WORKDIR "src/"
RUN chmod +x server.rb

ENTRYPOINT ["ruby" ,"server.rb"]