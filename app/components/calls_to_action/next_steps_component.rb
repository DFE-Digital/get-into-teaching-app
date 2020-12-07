module CallsToAction
  class NextStepsComponent < ViewComponent::Base
    def icon
      image_tag(
        asset_pack_path("media/images/calls-to-action/icon-person.svg"),
        width: 50,
        height: 50,
        alt: "Chat with a adviser online",
        class: "call-to-action__icon",
      )
    end
  end
end
