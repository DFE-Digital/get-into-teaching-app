module GetIntoTeachingApi
  module Types
    class Base < OpenStruct
      class_attribute :type_cast_rules
      self.type_cast_rules = {}.freeze

      def initialize(data)
        super type_cast_data(data)
      end

    private

      def type_cast_data(data)
        data.stringify_keys.tap do |duped|
          type_cast_rules.each do |key, cast_to|
            duped[key] = type_cast_value(cast_to, duped[key])
          end
        end
      end

      def type_cast_value(cast_to, value)
        return value if value.nil?

        if cast_to.is_a?(Symbol)
          internal_type_cast(cast_to, value)
        elsif cast_to.is_a?(Class)
          class_type_cast(cast_to, value)
        else
          raise UnknownTypeCastError
        end
      end

      def internal_type_cast(cast_to, value)
        case cast_to
        when :date then date_type_cast(value)
        else send(cast_to, value)
        end
      end

      def class_type_cast(klass, value)
        klass.new(value)
      end

      def date_type_cast(value)
        Date.parse(value)
      end
    end
  end
end
