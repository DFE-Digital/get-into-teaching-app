module Cards
  class ChatOnlineComponent < CardComponent
    def initialize(card:, **_options)
      super(card: card)
    end

    def border
      false
    end

    def header
      @header ||= "Get the answers you need"
    end

    def snippet
      @snippet ||= <<~SNIPPET
        If you have questions about getting into teaching, we can help you get
        the answers
      SNIPPET
    end

    def link_text
      @link_text ||= "Chat online"
    end

    def image
      # FIXME: change to image_pack_path once theres a new webpacker release
      @image ||= resolve_path_to_image("chat-online-card.jpg")
    end
  end
end
