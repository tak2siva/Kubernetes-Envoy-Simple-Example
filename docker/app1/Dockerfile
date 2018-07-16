FROM ruby

RUN ruby --version
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim
RUN gem install sinatra
RUN gem install faraday
RUN gem install grpc
RUN gem install grpc-tools
COPY src src
WORKDIR "src/"
RUN chmod +x server.rb

ENTRYPOINT ["ruby" ,"server.rb"]