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
      :is_virtual,
      :message,
      :name,
      :provider_contact_email,
      :provider_organiser,
      :provider_target_audience,
      :provider_website_url,
      :provider_website_url,
      :providers_list,
      :readable_id,
      :start_at,
      :summary,
      :type_id,
      :status_id,
      :web_feed_id,
      to: :event,
    )

    def video_id
      return nil if event.video_url.blank?

      event.video_url[/(v=|embed\/)(.{11})/, 2]
    end

    def venue_address
      return if event_building.blank?

      [
        event_building.venue,
        event_building.address_line1,
        event_building.address_line2,
        event_building.address_line3,
        event_building.address_city,
        event_building.address_postcode,
      ].compact
    end

    def has_location?
      event_building.present?
    end

    def online?
      is_online
    end

    def in_person?
      is_in_person
    end

    def location
      if show_venue_information?
        [event_building.venue,
         event_building.address_city,
         event_building.address_postcode].compact.join(", ")
      else
        event_building.address_city
      end
    end

    def event_type
      Crm::EventType.lookup_by_id(type_id)
    end

    def quote
      case event_type
      when "Get Into Teaching event"
        "So useful! I got answers to questions I didn't know I had yet and I'm so inspired and excited."
      end
    end

    def image
      case event_type
      when "Get Into Teaching event"
        get_into_teaching_event_image_details
      end
    end

    def allow_registration?
      Crm::EventStatus.new(@event).accepts_online_registration?
    end

    def open?
      Crm::EventStatus.new(@event).open?
    end

    def closed?
      Crm::EventStatus.new(@event).closed?
    end

    def show_provider_information?
      !type_id.in?([Crm::EventType.get_into_teaching_event_id])
    end

    def show_venue_information?
      !@event.is_online && @event.building.present?
    end

  private

    def get_into_teaching_event_image_details
      if online?
        {
          path: "static/images/content/event-signup/event-regional-online.jpg",
          alt: "An online Get Into Teaching event on a computer screen.",
        }
      else
        {
          path: "static/images/content/event-signup/event-regional.jpg",
          alt: "A busy Get Into Teaching event with people having one-on-one conversations with expert advisers and teachers",
        }
      end
    end

    def event_building
      @event.building
    end
  end
end
