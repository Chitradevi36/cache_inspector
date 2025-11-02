# frozen_string_literal: true
require "active_support/notifications"

module CacheInspector
  module Subscriber
    EVENTS = %w[
      cache_read.active_support
      cache_generate.active_support
      cache_write.active_support
      cache_delete.active_support
      cache_fetch_hit.active_support
    ].freeze

    def self.install!(config)
      return if @installed

      @config = config

      EVENTS.each do |event|
        ActiveSupport::Notifications.subscribe(event) do |*args|
          event_obj = ActiveSupport::Notifications::Event.new(*args)
          handle_event(event, event_obj)
        end
      end

      @installed = true
    end

    def self.handle_event(event, e)
      env = rails_env
      return unless @config.enabled?(env)

      key = e.payload[:key]
      value = e.payload[:value]
      size_kb = value.to_s.bytesize / 1024.0 if value

      msg = "#{@config.log_prefix} #{event} key=#{key}"

      case event
      when "cache_fetch_hit.active_support"
        msg << " (hit)"
      when "cache_generate.active_support"
        msg << " (miss -> generating)"
      when "cache_write.active_support"
        msg << " (write)"
        if size_kb && size_kb > @config.warn_large_size_kb
          msg << " ⚠️ large write: #{size_kb.round(1)}KB"
        end
      end

      if @config.log_payloads && value
        msg << " payload=#{truncate(value.inspect)}"
      end

      logger.info(msg)
    end

    def self.truncate(str, max = 150)
      str.length > max ? "#{str[0..max]}..." : str
    end

    def self.logger
      if defined?(Rails) && Rails.respond_to?(:logger)
        Rails.logger
      else
        @logger ||= Logger.new($stdout)
      end
    end

    def self.rails_env
      if defined?(Rails)
        Rails.env.to_sym
      else
        (ENV["RACK_ENV"] || "development").to_sym
      end
    end
  end
end
