module Cards
  class LatestEventComponent < CardComponent
    ALL_EVENTS_HEADER = "Find a Teacher Training Event".freeze
    ALL_EVENTS_SNIPPET = <<~SNIPPET.freeze
      Find an event to speak to real teachers and get your questions answered
      by our expert advisers. You can also find out what it is like to train
      and be in the classroom.
    SNIPPET

    attr_reader :page_data, :category, :event
    with_collection_parameter :card

    def initialize(card:, page_data: nil)
      super card: card

      @category = card["category"].to_s
      @page_data = page_data

      fetch_event
    end

    def border
      false
    end

    def header
      event ? "Event: #{event.name}" : ALL_EVENTS_HEADER
    end

    def snippet
      event ? event.summary : ALL_EVENTS_SNIPPET
    end

    def link_text
      event ? "View event" : "View events"
    end

    def link
      if event
        event_path event.readable_id
      else
        events_path
      end
    end

    def image
      # FIXME: change to image_pack_path once theres a new webpacker release
      @image ||= resolve_path_to_image("latest-event-card-image.jpg")
    end

  private

    def fetch_event
      @event = @page_data.latest_event_for_category(category)
    end
  end
end
