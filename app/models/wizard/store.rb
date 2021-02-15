module Wizard
  class Store
    delegate :keys, :to_h, :to_hash, to: :@data

    def initialize(data)
      raise InvalidBackingStore unless data.respond_to?(:[]=)

      @data = data
    end

    def [](key)
      @data[key.to_s]
    end

    def []=(key, value)
      @data[key.to_s] = value
    end

    def fetch(*keys)
      array_of_keys = Array.wrap(keys).flatten.map(&:to_s)
      Hash[array_of_keys.zip].merge(@data.slice(*array_of_keys))
    end

    def persist(attributes)
      @data.merge! attributes.stringify_keys

      true
    end

    def purge!
      @data.clear
    end

    class InvalidBackingStore < RuntimeError; end
  end
end
