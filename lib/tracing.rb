require 'newrelic_rpm'
require 'new_relic/agent/instrumentation/rack'
require 'new_relic/agent/method_tracer'

def enable_tracing
  to_trace = {
    Shutterbug::Handlers::ConvertHandler         => [:handle, :convert],
    Shutterbug::Handlers::JsFileHandler          => [:handle],
    Shutterbug::Handlers::FileHandlers::PngFile  => [:handle],
    Shutterbug::Handlers::FileHandlers::HtmlFile => [:handle],
    Shutterbug::Storage::S3Storage               => [:get_content, :initialize],
    Shutterbug::Storage::FileStorage             => [:get_content, :initialize],
    Shutterbug::PhantomJob              => [:rasterize],
    Shutterbug::CacheManager::NoCache            => [:find, :add_entry]
  }

  to_trace.each do |clz,methods_ary|
    clz.class_eval do
      include ::NewRelic::Agent::MethodTracer
      methods_ary.each do |method_symbol|
        add_method_tracer method_symbol
      end
    end  
  end
end