require 'newrelic_rpm'
require 'new_relic/agent/instrumentation/rack'
require 'new_relic/agent/method_tracer'

def enable_tracing
  to_trace = {
    Shutterbug::Handlers::ConvertHandler         => [:handle, :convert],
    Shutterbug::Handlers::JsFileHandler          => [:handle],
    Shutterbug::Handlers::FileHandler            => [:handle],
    Shutterbug::Handlers::DirectUploadHandler    => [:handle],
    Shutterbug::Storage::S3Storage               => [:get_content, :initialize],
    Shutterbug::Storage::FileStorage             => [:get_content, :initialize],
    Shutterbug::PhantomJob                       => [:rasterize, :initialize],
    Shutterbug::CacheManager::NoCache            => [:find, :add_entry, :initialize]
  }

  to_trace.each do |clz,methods_ary|
    clz.class_eval do
      clzname = clz.name.split("::").last
      include ::NewRelic::Agent::MethodTracer
      methods_ary.each do |method_symbol|
        trace_name = [clzname, method_symbol.to_s].join("#")
        add_method_tracer method_symbol, trace_name
      end
    end  
  end
end