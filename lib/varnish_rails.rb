require "varnish_rails/railtie"
require "varnish_rails/action_controller_methods"
require "varnish_rails/application_record_methods"
require "varnish_rails/varnish_rails_service"
require "varnish_rails/varnish_debug_color"

module VarnishRails

  ActionController::Base.class_eval do
    include ActionControllerMethods
  end

  application_record_class = defined?(ApplicationRecord) ? ApplicationRecord : ActiveRecord::Base
  application_record_class.class_eval do
    include ApplicationRecordMethods
  end

  # CONFIGURATION -----------------------------------------------------------------
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :enable, :url, :maxage_key, :maxage_value, :xkey_length, :header_xkey_purge, :header_x_ban_url, :print_requests

    def initialize
      @enable             = false
      @url                = 'http://localhost:6081'
      @maxage_key         = 's-maxage'
      @maxage_value       = 3600
      @xkey_length        = 12
      @header_xkey_purge  = 'xkey-purge'
      @header_x_ban_url   = 'x-ban-url'
      @print_requests     = false
    end
  end
  # CONFIGURATION -----------------------------------------------------------------

end
