$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "varnish_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "varnish_rails"
  s.version     = VarnishRails::VERSION
  s.authors     = ["iXmedia"]
  s.email       = ["suivi@ixmedia.com"]
  s.homepage    = "https://github.com/ixmedia/varnish_rails"
  s.summary     = "Add Varnish cache headers to controller actions."
  s.description = "Add Varnish cache headers to controller actions. Automatically purge instances and models on after_create, after_update and after_destroy callbacks."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ['>= 4.0', '< 6']

  s.add_development_dependency 'sqlite3', '~> 0'
end
