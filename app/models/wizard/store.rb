module Wizard
  class Store
    attr_reader :data
    delegate :keys, to: :data

    def initialize(data)
      raise InvalidBackingStore unless data.respond_to?(:[]=)

      @data = data
    end

    def [](key)
      data[key.to_s]
    end

    def []=(key, value)
      data[key.to_s] = value
    end

    def fetch(*keys)
      data.slice(*Array.wrap(keys).flatten.map(&:to_s)).stringify_keys
    end

    def persist(attributes)
      data.merge! attributes.stringify_keys

      true
    end

    def purge!
      data.clear
    end

    def to_camelized_hash
      data.transform_keys { |k| k.camelize(:lower).to_sym }
    end

    class InvalidBackingStore < RuntimeError; end
  end
end
