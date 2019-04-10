class VarnishRailsService

  # == Extensions ===========================================================

  require 'net/http'

  include Singleton

  # == Constants ============================================================

  # == Attributes ===========================================================

  # == Callbacks ============================================================

  # == Relationships ========================================================

  # == Validations ==========================================================

  # == Scopes ===============================================================

  # == Instance Methods =====================================================

  # == Class Methods ========================================================

  def self.purge_xkey_cache(*xkeys)
    return if !VarnishRails.configuration.enable

    xkey_purge = ''
    xkeys.each do |xkey|
      xkey_purge = xkey_purge + xkey + ' '
    end
    xkey_purge = xkey_purge.strip

    uri                                                         = URI.parse(VarnishRails.configuration.url)
    http_request                                                = Net::HTTPGenericRequest.new("PURGE", false, false, uri)
    http_request[VarnishRails.configuration.header_xkey_purge]  = xkey_purge
    req_options                                                 = { use_ssl: uri.scheme == "https" }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(http_request)
    end

    puts "Varnish - purge_xkey_cache - #{xkey_purge}".varnish_debug_color if VarnishRails.configuration.print_requests
    puts response.inspect.varnish_debug_color if VarnishRails.configuration.print_requests
  end

  def self.purge_cache(url)
    return if !VarnishRails.configuration.enable

    uri           = URI.parse("#{VarnishRails.configuration.url}#{url}")
    http_request  = Net::HTTPGenericRequest.new("PURGE", false, false, uri)
    req_options   = { use_ssl: uri.scheme == "https" }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(http_request)
    end

    puts "Varnish - purge_cache - #{url}".varnish_debug_color if VarnishRails.configuration.print_requests
    puts response.inspect.varnish_debug_color if VarnishRails.configuration.print_requests
  end

  def self.ban_cache(pattern)
    return if !VarnishRails.configuration.enable

    uri                                                       = URI.parse(VarnishRails.configuration.url)
    http_request                                              = Net::HTTPGenericRequest.new("BAN", false, false, uri)
    http_request[VarnishRails.configuration.header_x_ban_url] = pattern
    req_options                                               = { use_ssl: uri.scheme == "https" }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(http_request)
    end

    puts "Varnish - ban_cache - #{pattern}".varnish_debug_color if VarnishRails.configuration.print_requests
    puts response.inspect.varnish_debug_color if VarnishRails.configuration.print_requests
  end

end
