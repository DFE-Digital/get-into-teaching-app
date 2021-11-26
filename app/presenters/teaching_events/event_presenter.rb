module TeachingEvents
  class EventPresenter
    attr_reader :event

    def initialize(event)
      @event = event
    end

    delegate(
      :building,
      :description,
      :end_at,
      :is_in_person,
      :is_online,
      :is_online,
      :message,
      :name,
      :provider_contact_email,
      :provider_organiser,
      :provider_target_audience,
      :provider_website_url,
      :provider_website_url,
      :providers_list,
      :readable_id,
      :scribble_id,
      :start_at,
      :type_id,
      to: :event,
    )

    def venue_address
      building = @event.building

      return if building.blank?

      [
        building.venue,
        building.address_line1,
        building.address_line2,
        building.address_line3,
        building.address_city,
        building.address_postcode,
      ].compact
    end

    def event_type
      GetIntoTeachingApiClient::Constants::EVENT_TYPES.invert[type_id]
    end

    def quote
      case event_type
      when "Train to Teach event", "Question Time"
        "So useful! I got answers to questions I didn't know I had yet and I'm so inspired and excited."

      # FIXME: the alternatives quotes might be added later
      when "Online event"
        nil
      when "School or University event"
        nil
      end
    end
  end
end
