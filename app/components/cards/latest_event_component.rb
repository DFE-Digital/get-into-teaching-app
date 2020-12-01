module Cards
  class LatestEventComponent < CardComponent
    attr_reader :page_data, :category
    with_collection_parameter :card

    def initialize(card:, page_data: nil)
      super card: card

      @category = card["category"]
      @page_data = page_data
    end

    def border
      false
    end

    def header
      event.name
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
      @image ||= resolve_path_to_image("latest-event-card-image.jpg")
    end

  private

    def event
      @event ||= @page_data.latest_event_for_category(category)
    end
  end
end
