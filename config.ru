require 'shutterbug'
require 'rack/cors'
libdir = File.join(File.dirname(__FILE__),'lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'tracing.rb'

enable_tracing()

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => :any
  end
end

use Shutterbug::Rackapp do |config|
  config.uri_prefix       = "http://shutterbug.herokuapp.com/"
  config.path_prefix      = "/shutterbug"
  config.phantom_bin_path = "/app/vendor/phantomjs/bin/phantomjs"
  config.s3_key           = ENV['S3_KEY']
  config.s3_secret        = ENV['S3_SECRET']
  config.s3_bin           = "ccshutterbugtest"
end


app = proc do |env|
  [200, { 'Content-Type' => 'text/html' }, ['move along']]
end

run app
