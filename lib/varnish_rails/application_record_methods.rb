module ApplicationRecordMethods

  extend ActiveSupport::Concern

  included do

    # == Extensions ===========================================================

    # == Constants ============================================================

    # == Attributes ===========================================================

    class_attribute :varnish_purge_on_commit

    # == Callbacks ============================================================

    after_initialize  :varnish_configure

    after_create      :purge_cache_by_varnish_class_name
    after_destroy     :purge_cache_by_varnish_class_name
    after_update      :purge_cache_by_varnish_id

    # == Relationships ========================================================

    # == Validations ==========================================================

    # == Scopes ===============================================================

    # == Instance Methods =====================================================
    def varnish_configure
      self.class.varnish_purge_on_commit = true if self.class.varnish_purge_on_commit.nil?
    end

    def varnish_class_name
      return self.class.varnish_class_name
    end

    def varnish_class_name_fk
      return self.class.varnish_class_name_fk
    end

    def varnish_foreign_keys
      return self.class.varnish_foreign_keys
    end

    def varnish_id
      return self.class.varnish_encode([self.class.name, id].join('-')) if defined?(id)
    end

    private

    def purge_cache_by_varnish_class_name
      self.class.purge_cache_by_varnish_class_name
    end

    def purge_cache_by_varnish_id
      VarnishRailsService::purge_xkey_cache(varnish_id, varnish_class_name_fk) if (self.class.can_purge && varnish_id.present? && !/.+::Translation/.match(self.class.name) && self.class.varnish_purge_on_commit)
    end

    # == Class Methods ========================================================

    def self.can_purge
      return VarnishRails.configuration.included_models.include?(self::name) if VarnishRails.configuration.included_models.present?
      return !VarnishRails.configuration.excluded_models.include?(self::name) if VarnishRails.configuration.excluded_models.present?
      return true
    end

    def self.varnish_class_name(namespace='')
      class_name = namespace.present? ? [self.name, namespace].join('-') : self.name
      return self.varnish_encode(class_name)
    end

    def self.varnish_class_name_fk
      return self.varnish_class_name('fk')
    end

    def self.varnish_foreign_keys
      foreign_keys = []
      classes = self.reflect_on_all_associations.map(&:class_name).select{|c| !/.+::Translation/.match(c)}
      foreign_keys = classes.map(&:constantize).map(&:varnish_class_name_fk) if classes.length > 0
      return foreign_keys
    end

    def self.purge_cache_by_varnish_class_name
      VarnishRailsService::purge_xkey_cache(self::varnish_class_name, self::varnish_class_name_fk) if (self::can_purge && self::varnish_purge_on_commit)
    end

    def self.varnish_encode(value)
      Digest::MD5.hexdigest([Rails.application.engine_name, Rails.env, value].join('-'))[0,VarnishRails.configuration.xkey_length]
    end

  end

  module ClassMethods
    def is_updated_via_import(value=true)
      self.varnish_purge_on_commit = !value
    end
  end

end
