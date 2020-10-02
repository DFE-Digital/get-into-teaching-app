module Events
  class EventBoxComponent < ViewComponent::Base
    attr_reader :title, :event, :title, :description, :type, :online, :location

    def initialize(event)
      @event       = event
      @title       = event.name
      @description = event.summary
      @type        = event.type_id
      @online      = event.is_online
      @location    = event.building&.address_city
    end

    def datetime
      helpers.format_event_date(event, stacked: false)
    end

    def type_name
      helpers.name_of_event_type(type)
    end

    def type_color
      helpers.event_type_color(type)
    end

    def formatted_location
      helpers.safe_format(location)
    end
  end
end
