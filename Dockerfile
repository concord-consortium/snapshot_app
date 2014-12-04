# snapshot server, version 0.0 

FROM ubuntu:14.04

ENV PORT 8888
ENV SB_PHANTOM_BIN /usr/bin/phantomjs

MAINTAINER knowuh@gmail.com

# Base Ruby stuff:
RUN adduser --home /home/webapp --disabled-password --gecos '' webapp &&\
    adduser webapp sudo &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN apt-get update &&\
    apt-get install -y wget build-essential checkinstall zlib1g-dev libssl-dev libreadline6-dev libyaml-dev git

WORKDIR /tmp
RUN wget http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.5.tar.gz && \
  tar -xvzf ruby-2.1.5.tar.gz

WORKDIR /tmp/ruby-2.1.5
RUN ./configure --prefix=/usr/local && \
 make &&\
 make install
WORKDIR /tmp
RUN rm -rf /tmp/ruby-2.1.5

RUN gem install bundler

# For phantomjs
RUN apt-get install -y phantomjs

USER webapp

# Update our gems, and cache it, see:
# see : http://bit.ly/1FrHZyn 
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock  Gemfile.lock
RUN bundle install

WORKDIR /home/webapp/
ADD config         /home/webapp/config
ADD demo           /home/webapp/demo
ADD lib            /home/webapp/lib
ADD config.ru      /home/webapp/config.ru
ADD Gemfile        /home/webapp/Gemfile
ADD Gemfile.lock   /home/webapp/Gemfile.lock
ADD unicorn.rb     /home/webapp/unicorn.rb

# TODO add volumes if needed
# VOLUME ["/home/webapp/log"]

# Define default command.
# docker run -d -p 80:8888 knowuh/ruby193
CMD bundle exec unicorn -p 8888 -c ./unicorn.rb

# Expose ports.
EXPOSE 8888

# ENV needs:
# NEW_RELIC_LICENSE_KEY
# S3_BIN
# S3_SECRET
# S3_KEY