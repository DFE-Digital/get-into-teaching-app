module CallsToAction
  class GetSupportBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :links

    include ContentHelper

    def initialize(
      title: "Get free support",
      image: "get-support-block-promo.jpg",
      title_color: "yellow",
      links: [
        { text: "Get an adviser", url: "/teacher-training-adviser/sign_up/identity" },
        { text: "Attend a Get Into Teaching event", url: "/events/about-get-into-teaching-events" },
        { text: "Get tailored email advice", url: "/mailinglist/signup/name" },
        { text: "Get school experience", url: "/train-to-be-a-teacher/get-school-experience" },
      ]
    )

      super
      @title = title
      @image = image
      @title_color = title_color
      @links = links
    end
  end
end
