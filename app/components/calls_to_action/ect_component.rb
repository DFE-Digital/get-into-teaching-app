module CallsToAction
  class EctComponent < ViewComponent::Base
    def icon
      image_pack_tag("media/images/icon-school-black.svg",
                     width: 50,
                     height: 50,
                     alt: "",
                     class: "call-to-action__icon")
    end
  end
end
