# varnish_rails
Add Varnish cache headers to controller actions. Automatically purge instances and models on `after_create`, `after_update` and `after_destroy` callbacks.

## Installation
1. Add this line to your application's Gemfile:

```ruby
gem 'varnish_rails'
```

2. Run
```bash
$ bundle install
```

3. Install VarnishRails
```bash
$ rails generate varnish_rails:install
```

## Configuration
1. Complete the `config/initializers/varnish_rails.rb` file.

## Usage
1. Add `before_action :set_varnish_headers(max_age_in_seconds)` in controllers that you wanna cache.

2. Add calls to `add_to_varnish_xkey_header(my_collection_or_item)` in the cached controller actions to automatically generate the Varnish xkeys.

3. For models that don't have to be purged automatically, add the following line `is_updated_via_import` to the model. You can then call `MyModel::purge_cache_by_varnish_class_name` to purge all cached pages that use this model.

## Contributing
- Mario Bouchard

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
