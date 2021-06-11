module Cards
  class LatestEventComponent < CardComponent
    attr_reader :page_data, :category, :event

    def initialize(card:, page_data: nil)
      super card: card

      @category = card["category"].to_s
      @card = card
      @page_data = page_data

      @image_description = "A photograph of staff chatting in a school setting"

      fetch_event
    end

    def border
      false
    end

    def header
      "Event: #{event.name}"
    end

    def snippet
      event.summary
    end

    def link_text
      "View event"
    end

    def link
      event_path event.readable_id
    end

    def image
      # FIXME: change to image_pack_path once theres a new webpacker release
      @image ||= "media/images/latest-event-card.jpg"
    end

    def call
      event ? super : render(find_events_component)
    end

  private

    def fetch_event
      @event = @page_data.latest_event_for_category(category)
    rescue Events::Category::UnknownEventCategory => e
      Sentry.capture_exception(e)
      @event = nil
    end

    def find_events_component
      FindEventsComponent.new(card: @card)
    end
  end
end
