module Cards
  class FindEventsComponent < CardComponent
    HEADER = "Find a Teacher Training Event".freeze
    SNIPPET = <<~SNIPPET.freeze
      Find an event to speak to real teachers and get your questions answered
      by our expert advisers. You can also find out what it is like to train
      and be in the classroom.
    SNIPPET

    def initialize(card:, page_data: nil)
      super card: card
      @page_data = page_data
      @image_description = "A photograph of staff chatting in a school setting"
    end

    def border
      false
    end

    def header
      HEADER
    end

    def snippet
      SNIPPET
    end

    def link_text
      "View events"
    end

    def link
      events_path
    end

    def image
      # FIXME: change to image_pack_path once theres a new webpacker release
      @image ||= "media/images/latest-event-card.jpg"
    end
  end
end
