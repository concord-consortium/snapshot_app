
require 'shutterbug'
require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '/shutterbug/*', :headers => :any, :methods => :any
  end
end

use Shutterbug::Rackapp do |config|
  config.uri_prefix = "http://shutterbug.herokuapp.com/"
  config.path_prefix = "/shutterbug"
end

app = Rack::Directory.new "."

run app
