module Events
  class EventBoxComponent < ViewComponent::Base
    attr_reader :title, :event, :title, :description, :type, :online, :location

    delegate :format_event_date, :name_of_event_type, :event_type_color, :safe_format, to: :helpers

    def initialize(event)
      @event       = event
      @title       = event.name
      @description = event.summary
      @type        = event.type_id
      @online      = event.is_online
      @location    = event.building&.address_city
    end

    def datetime
      format_event_date(event, stacked: false)
    end

    def type_name
      t("event_types.#{type}.name.singular")
    end

    def type_color
      event_type_color(type)
    end

    def formatted_location
      safe_format(location)
    end

    # FIXME move all the logic that determines whether this
    #       event is online here. There are currently two
    #       distinct ways, the is_online flag and checking
    #       whether the event type's name is 'Online Event'
    def online?
      online
    end
  end
end
