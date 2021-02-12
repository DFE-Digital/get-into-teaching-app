module Wizard
  class Step
    include ActiveModel::Model
    include ActiveModel::Attributes
    include ActiveModel::Validations::Callbacks

    class << self
      def key
        name.split("::").last.underscore
      end

      def title
        key.humanize
      end
    end

    delegate :key, to: :class
    delegate :title, to: :class
    alias_method :id, :key

    def initialize(wizard, store, attributes = {}, *args)
      @wizard = wizard
      @store = store
      super(*args)
      assign_attributes attributes_from_store
      assign_attributes attributes
    end

    def save
      return false unless valid?

      persist_to_store
    end

    def can_proceed?
      true
    end

    def persisted?
      !id.nil?
    end

    def optional?
      false
    end

    def skipped?
      return false unless optional?

      attributes_in_crm.values.all?(&:present?)
    end

    def flash_error(message)
      errors.add(:base, message)
    end

    def export
      return {} if skipped?

      Hash[attributes.keys.zip([])].merge attributes_from_store
    end

    def method_missing(method_name, *arguments, &block)
      return @store[method_name] if respond_to_missing?(method_name)

      super
    end

    def respond_to_missing?(method_name, include_private = false)
      if method_name.to_s =~ /(.*)#{Base::ATTRIBUTE_IN_CRM_SUFFIX}/
        respond_to?(Regexp.last_match(1), include_private)
      else
        super
      end
    end

  private

    def attributes_in_crm
      attributes.each_with_object({}) do |(k), hash|
        in_crm_key = "#{k}#{Base::ATTRIBUTE_IN_CRM_SUFFIX}"
        hash[in_crm_key] = @store[in_crm_key]
      end
    end

    def attributes_from_store
      @store.fetch attributes.keys
    end

    def persist_to_store
      @store.persist attributes
    end
  end
end
