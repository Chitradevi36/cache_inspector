# frozen_string_literal: true
require "cache_inspector/version"
require "cache_inspector/config"
require "cache_inspector/subscriber"

module CacheInspector
  class << self
    def config
      @config ||= Config.new
    end

    def configure
      yield config
      self
    end

    def install!
      Subscriber.install!(config)
      self
    end
  end
end

# Auto-install in Rails
if defined?(Rails::Railtie)
  class CacheInspector::Railtie < Rails::Railtie
    initializer "cache_inspector.install" do
      CacheInspector.install!
    end
  end
end
