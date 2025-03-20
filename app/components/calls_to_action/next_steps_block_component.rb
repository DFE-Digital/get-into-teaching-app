module CallsToAction
  class NextStepsBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :links

    include ContentHelper

    def initialize(
      title: "Take the next step",
      image: "next-steps-block-promo.jpg",
      title_color: "yellow",
      links: [
        { text: "Get an adviser", url: "/teacher-training-adviser/sign_up/identity" },
        { text: "Attend a Get Into Teaching event", url: "/events/about-get-into-teaching-events" },
        { text: "Get tailored email advice", url: "/mailinglist/signup/name" },
        { text: "How to become a teacher", url: "/steps-to-become-a-teacher" },
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
