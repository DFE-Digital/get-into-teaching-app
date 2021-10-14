module Events
  module Cards
    class BaseComponent < ViewComponent::Base
      attr_reader :title

      def initialize(event)
        @event       = event
        @title       = event.name
        @type        = event.type_id
        @online      = event.is_online
        @virtual     = event.is_virtual

        super
      end

      def setting
        if @online || @virtual
          "Online"
        else
          "In person"
        end
      end

      def location
        "TODO"
      end

      def date
        "TODO"
      end

      def time_and_duration
        "TODO"
      end
    end
  end
end
