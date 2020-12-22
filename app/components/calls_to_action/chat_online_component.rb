module CallsToAction
  class ChatOnlineComponent < ViewComponent::Base
    def icon
      image_pack_tag("media/images/icon-question.svg",
                     width: 50,
                     height: 50,
                     alt: "Chat with a adviser online",
                     class: "call-to-action__icon")
    end
  end
end
