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
      :scribble_id,
      :start_at,
      :type_id,
      :status_id,
      :video_url,
      :web_feed_id,
      to: :event,
    )

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
      EventType.lookup_by_id(type_id)
    end

    def quote
      case event_type
      when "Train to Teach event", "Question Time"
        "So useful! I got answers to questions I didn't know I had yet and I'm so inspired and excited."

      when "Online event"
        nil
      when "School or University event"
        nil
      end
    end

    def image
      case event_type
      when "Train to Teach event", "Question Time"
        [
          "media/images/content/event-signup/birmingham-event-1.jpg",
          { alt: "A bustling Train to Teach event taking place in a church, busy with stalls and visitors" },
        ]
      when "Online event"
        nil
      when "School or University event"
        nil
      end
    end

    def allow_registration?
      EventStatus.new(@event).accepts_online_registration?
    end

    def open?
      EventStatus.new(@event).open?
    end

    def closed?
      EventStatus.new(@event).closed?
    end

    def show_provider_information?
      !type_id.in?([EventType.question_time_event_id, EventType.train_to_teach_event_id])
    end

    def show_venue_information?
      !@event.is_online && @event.building.present?
    end

  private

    def event_building
      @event.building
    end
  end
end
