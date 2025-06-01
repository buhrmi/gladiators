# config/initializers/geocoder.rb
Geocoder.configure(
  # Geocoding options
  timeout: 2,                 # geocoding service timeout (secs)
  lookup: :ipinfo_io,         # name of geocoding service (symbol)
  # ip_lookup: :maxmind_local,     # name of IP address geocoding service (symbol)
  # ip_lookup: :maxmind,     # name of IP address geocoding service (symbol)
  # language: :en,              # ISO-639 language code
  use_https: true,           # use HTTPS for lookup requests? (if supported)
  # http_proxy: nil,            # HTTP proxy server (user:pass@host:port)
  # https_proxy: nil,           # HTTPS proxy server (user:pass@host:port)
  api_key: "a8b736df7d7d42",               # API key for geocoding service
  # cache: Redis.new,                 # cache object (must respond to #[], #[]=, and #del)
  # cache_prefix: 'geocoder:',  # prefix (string) to use for all cache keys
  units: :km,
)
