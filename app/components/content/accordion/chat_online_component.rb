module Content
  module Accordion
    class ChatOnlineComponent < ViewComponent::Base
      def icon
        image_tag(
          asset_pack_path("media/images/calls-to-action/chat-icon.png"),
          width: 50,
          height: 50,
          alt: "Chat with a advisor online"
        )
      end
    end
  end
end
