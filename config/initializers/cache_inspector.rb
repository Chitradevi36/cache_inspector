CacheInspector.configure do |config|
  config.enabled_environments = %i[development test]
  config.warn_large_size_kb   = 100   # warn if payload > 100KB
  config.log_payloads         = false
  config.log_prefix           = "[CacheInspector]"
end
