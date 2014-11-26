require 'shutterbug'
require 'rack/cors'
libdir = File.join(File.dirname(__FILE__),'lib')
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)
require 'tracing.rb'

enable_tracing()

use Rack::Cors do
  allow do
    origins '*'
    resource '*', :headers => :any, :methods => [:get, :post, :options]
  end
end

use Shutterbug::Rackapp do |config|
  config.uri_prefix       = ENV['SB_SNAP_URI']    || "http://shutterbug.herokuapp.com/"
  config.path_prefix      = ENV['SB_PATH_PREFIX'] || "/shutterbug"
  config.phantom_bin_path = ENV['SB_PHANTOM_BIN'] || "/app/vendor/phantomjs/bin/phantomjs"
  config.s3_key           = ENV['S3_KEY']
  config.s3_secret        = ENV['S3_SECRET']
  config.s3_bin           = ENV['S3_BIN']
end

# app = proc { |env| [200, { 'Content-Type' => 'text/html' }, ['move along']] }
app = Rack::Directory.new "demo"

run app