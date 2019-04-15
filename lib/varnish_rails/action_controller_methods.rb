module ActionControllerMethods

  private

  def set_varnish_headers(max_age_in_seconds=VarnishRails.configuration.maxage_value)
    if VarnishRails.configuration.enable
      response.headers['Cache-Control'] = "public, #{VarnishRails.configuration.maxage_key}=#{max_age_in_seconds}"
      @varnish_headers_are_set = true
    end
  end

  def add_to_varnish_xkey_header(*collections)
    return if !VarnishRails.configuration.enable

    xkey_string = response.headers['xkey'] || ''
    xkey        = xkey_string.split(' ')

    collections.each do |collection|
      if collection.is_a?(ActiveRecord::Relation) || collection.is_a?(Array)
        if collection.length > 0
          my_collection = collection.first
          collection.each { |item| xkey << item.varnish_id }
        end
      elsif collection.present?
        my_collection = collection
        xkey << collection.varnish_id
      end

      xkey << my_collection.varnish_class_name if my_collection.present?
      xkey = xkey.concat(my_collection.varnish_foreign_keys) if my_collection.present?
    end

    xkey = xkey.uniq
    response.headers['xkey'] = xkey.join(' ') if xkey.length > 0
  end

end
