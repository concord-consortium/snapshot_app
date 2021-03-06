# snapshot server, version 0.0

FROM knowuh/cc-ruby2-phantom2

ENV PORT 8888
ENV SB_PHANTOM_BIN /usr/bin/phantomjs
ENV HOME /home/webapp

# add user info
RUN adduser --home /home/webapp --disabled-password --gecos '' webapp &&\
    adduser webapp sudo &&\
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Update our gems, and cache it, see:  http://bit.ly/1FrHZyn
# WORKDIR /tmp
# ADD Gemfile /tmp/Gemfile
# ADD Gemfile.lock  /tmp/Gemfile.lock
# RUN chown webapp /tmp/Gemfile
# RUN chown webapp /tmp/Gemfile.lock
# USER webapp
# RUN bundle install

WORKDIR /home/webapp/
ADD Gemfile        /home/webapp/Gemfile
ADD Gemfile.lock   /home/webapp/Gemfile.lock
RUN sudo chown -R webapp /home/webapp
USER webapp
RUN bundle install
ADD config         /home/webapp/config
ADD demo           /home/webapp/demo
ADD lib            /home/webapp/lib
ADD config.ru      /home/webapp/config.ru
ADD unicorn.rb     /home/webapp/unicorn.rb
RUN sudo chown -R webapp /home/webapp

# TODO add volumes if needed
# VOLUME ["/home/webapp/log"]

# Expose ports.
EXPOSE 8888

# Define the default run command for this image
# use like `docker run -d -p 80:8888 <this image name>`
CMD bundle exec unicorn -p 8888 -c ./unicorn.rb

# NOTE: ENV expects to find:
#   * NEW_RELIC_LICENSE_KEY
#   * S3_BIN
#   * S3_SECRET
#   * S3_KEY
