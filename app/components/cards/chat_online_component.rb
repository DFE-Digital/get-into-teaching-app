module Cards
  class ChatOnlineComponent < CardComponent
    def initialize(card:, **_options)
      super(card: card)

      @image_description = "A photograph of a child with their hand raised"
    end

    def border
      false
    end

    def header
      @header ||= "Get the answers you need"
    end

    def snippet
      @snippet ||= <<~SNIPPET
        Chat online with one of our teacher training experts. They're available Monday-Friday between 8:30am and 5:30pm.
      SNIPPET
    end

    def image
      # FIXME: change to image_pack_path once theres a new webpacker release
      @image ||= "media/images/chat-online-card.jpg"
    end
  end
end
