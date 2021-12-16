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
        Chat online with one of our teacher training experts. They're available Monday to Friday between 8:30am and 5:30pm. Chat will be unavailable from 1pm on 24 December until 29 December. It will also be unavailable from 1pm on 31 December and be closed on 3 January. Responses may be slower over the Christmas period.
      SNIPPET
    end

    def image
      # FIXME: change to image_pack_path once theres a new webpacker release
      @image ||= "media/images/chat-online-card.jpg"
    end
  end
end
