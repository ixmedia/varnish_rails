VarnishRails.configure do |config|

  # To enable the varnish headers and purge calls
  config.enable             = ENV['VARNISH'] == "true" ? true : false

  # The varnish server URL (ex: http://localhost:6081)
  config.url                = ENV['VARNISH_URL']

  # The header max-age key to used
  config.maxage_key         = ENV['VARNISH_MAXAGE_KEY'] || 's-maxage'

  # The default max-age value
  config.maxage_value       = ENV['VARNISH_MAXAGE_VALUE'] || 3600

  # The xkey length that will be generated
  config.xkey_length        = ENV['VARNISH_XKEY_LENGTH'] || 12

  # The header for the xkey purge
  config.header_xkey_purge  = ENV['VARNISH_XKEY_PURGE'] || 'xkey-purge'

  # The header for the ban purge
  config.header_x_ban_url   = ENV['VARNISH_X_BAN_URL'] || 'x-ban-url'

  # Print requests
  config.print_requests     = ENV['VARNISH_PRINT_REQUESTS'] == "true" ? true : false
end

# Flush the Varnish cache when the app starts
VarnishRailsService::ban_cache('.+') unless File.basename($0) == 'rake'
