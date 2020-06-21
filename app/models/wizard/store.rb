module Wizard
  class Store
    attr_reader :data
    delegate :[], :[]=, to: :data

    def initialize(data)
      raise InvalidBackingStore unless data.respond_to?(:[]=)

      @data = data.with_indifferent_access
    end

    def fetch(*keys)
      data.slice(*Array.wrap(keys).flatten.map(&:to_s)).stringify_keys
    end

    def persist(attributes)
      data.merge! attributes.stringify_keys

      true
    end

    class InvalidBackingStore < RuntimeError; end
  end
end
