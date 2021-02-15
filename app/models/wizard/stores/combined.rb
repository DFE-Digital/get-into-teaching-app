module Wizard
  module Stores
    class Combined < ::Wizard::Store
      delegate :keys, :to_h, :to_hash, to: :combined_data

      def initialize(app_data, crm_data = {})
        @crm_data = crm_data
        super(app_data)
      end

      def [](key)
        combined_data[key.to_s]
      end

      def crm(key)
        @crm_data[key.to_s]
      end

      def fetch(*keys, source: :both)
        array_of_keys = Array.wrap(keys).flatten.map(&:to_s)
        Hash[array_of_keys.zip].merge(choose_store(source).slice(*array_of_keys))
      end

      def persist(attributes, source: :app)
        raise ArgumentError unless %i[app crm].include?(source)

        choose_store(source).merge! attributes.stringify_keys

        true
      end

      def purge!
        @crm_data.clear
        super
      end

    private

      def choose_store(source)
        case source
        when :crm then @crm_data
        when :app then @data
        else combined_data
        end
      end

      def combined_data
        @crm_data.merge(@data)
      end
    end
  end
end
