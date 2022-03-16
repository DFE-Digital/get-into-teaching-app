module CallsToAction
  class NextStepsComponent < ViewComponent::Base
    def icon
      image_pack_tag("media/images/icon-person.svg",
                     width: 50,
                     height: 50,
                     alt: "",
                     class: "call-to-action__icon")
    end
  end
end
