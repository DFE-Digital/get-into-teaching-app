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

    def show?
      !skipped? && !hidden?
    end

    # Step not shown and data not exported if skipped
    def skipped?
      false
    end

    # Step not shown, but data still exported if hidden
    def hidden?
      return false unless optional?

      @store.fetch(attribute_names, source: :crm).values.all?(&:present?)
    end

    # Step will be hidden if all attributes are pre-filled from CRM
    def optional?
      false
    end

    def flash_error(message)
      errors.add(:base, message)
    end

    def export
      return {} if skipped?

      Hash[attributes.keys.zip([])].merge attributes_from_store
    end

  private

    def attributes_from_store
      @store.fetch attributes.keys
    end

    def persist_to_store
      @store.persist attributes
    end
  end
end
