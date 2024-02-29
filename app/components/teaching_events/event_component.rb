module TeachingEvents
  class EventComponent < ViewComponent::Base
    attr_reader :title, :type, :slug

    def initialize(event:)
      @event     = event
      @title     = event.name
      @type      = Crm::EventType.new(event)
      @online    = event.is_online
      @in_person = event.building.present?
      @start_at  = event.start_at
      @end_at    = event.end_at
      @slug      = event.readable_id

      super
    end

    delegate :provider_event?, to: :type

    delegate :get_into_teaching_event?, to: :type

    def online?
      @online
    end

    def in_person?
      @in_person && !online?
    end

    def event_type
      helpers.event_type_name(type.type_id)
    end

    def location
      @event&.building&.address_city
    end

    def date
      @start_at.to_formatted_s(:event)
    end

    def times
      safe_join([@start_at.to_formatted_s(:time), @end_at.to_formatted_s(:time)], "&ndash;".html_safe)
    end

    def image
      image_path = "static/images/content/event-signup/event-regional#{'-online' if online?}-listing.jpg"
      helpers.image_pack_tag(image_path, **helpers.image_alt_attribs(image_path))
    end

    def classes
      class_names(
        "event",
        "event--get-into-teaching" => get_into_teaching_event?,
        "event--regular" => !get_into_teaching_event?,
        "event--training-provider" => provider_event?,
      )
    end
  end
end
