FROM ruby:2.5.0-alpine3.7

RUN ruby --version
RUN gem install sinatra
RUN apk add --no-cache --update curl
COPY server.rb ./server.rb
RUN chmod +x server.rb

ENTRYPOINT ["ruby" ,"server.rb"]