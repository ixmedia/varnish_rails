module VarnishRails
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_config_file
        template 'varnish_rails.rb', 'config/initializers/varnish_rails.rb'
      end
    end
  end
end
