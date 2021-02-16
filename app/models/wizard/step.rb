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

    def skipped?
      return false unless optional?

      @store.fetch(attribute_names, source: :crm).values.all?(&:present?)
    end

    def optional?
      false
    end

    def flash_error(message)
      errors.add(:base, message)
    end

    def export
      attributes = skipped? ? attributes_from_crm : attributes_from_store
      Hash[attributes.keys.zip([])].merge attributes
    end

  private

    def attributes_from_crm
      @store.fetch attributes.keys, source: :crm
    end

    def attributes_from_store
      @store.fetch attributes.keys
    end

    def persist_to_store
      @store.persist attributes
    end
  end
end
