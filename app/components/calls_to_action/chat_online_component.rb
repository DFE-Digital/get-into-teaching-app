module CallsToAction
  class ChatOnlineComponent < ViewComponent::Base
    attr_accessor :title, :text, :button_text

    def initialize(title: default_title, text: default_text, button_text: default_button_text)
      super

      @title       = title
      @text        = text
      @button_text = button_text
    end

    def icon
      image_pack_tag("media/images/icon-question.svg",
                     width: 50,
                     height: 50,
                     alt: "Chat with a adviser online",
                     class: "call-to-action__icon")
    end

  private

    def default_title
      "Chat to us"
    end

    def default_text
      "If you're unsure whether your qualifications are equivalent, you can chat to us."
    end

    def default_button_text
      "Chat online"
    end
  end
end
