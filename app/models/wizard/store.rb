module Wizard
  class Store
    attr_reader :data
    delegate :[], :[]=, to: :data

    def initialize(data)
      raise InvalidBackingStore unless data.respond_to?(:[]=)

      @data = data
    end

    def fetch(*keys)
      data.slice(*Array.wrap(keys))
    end

    class InvalidBackingStore < RuntimeError; end
  end
end
