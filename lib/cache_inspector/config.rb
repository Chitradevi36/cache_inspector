# frozen_string_literal: true
module CacheInspector
  class Config
    attr_accessor :enabled_environments, :log_prefix, :warn_large_size_kb, :log_payloads

    def initialize
      @enabled_environments = %i[development test]
      @log_prefix           = "[CacheInspector]"
      @warn_large_size_kb   = 100  # warn if payload > 100 KB
      @log_payloads         = false
    end

    def enabled?(env)
      @enabled_environments.map(&:to_sym).include?(env.to_sym)
    end
  end
end
