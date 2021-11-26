module TeachingEvents
  class EventPresenter
    attr_reader :event

    def initialize(event)
      @event = event
    end

    delegate(
      :name,
      :start_at,
      :end_at,
      :building,
      :is_online,
      :type_id,
      :readable_id,
      :description,
      :is_in_person,
      :is_online,
      :provider_website_url,
      :scribble_id,
      to: :event,
    )

    def message
      @event.message
    end

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

    def providers_list
      @event.providers_list
    end
  end
end
