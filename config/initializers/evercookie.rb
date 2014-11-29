Evercookie.setup do |config|
  # path for evercookie controller
  config.namespace = :cake_evercookie

  # name of javascript class to be used for evercookie
  config.js_class = :cake_evercookie

  # hash name base for session storage variables
  config.hash_name = :cake_evercookie

  # cookie name for cache storage
  config.cookie_cache = :cake_evercookie_cache

  # cookie name for png storage
  config.cookie_png = :cake_evercookie_png

  # cookie name for etag storage
  config.cookie_etag = :cake_evercookie_etag
end