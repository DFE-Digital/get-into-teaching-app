module CallsToAction
  class LifeasateacherBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :links

    include ContentHelper

    def initialize(
      title: "Life as a teacher",
      image: "life-as-a-teacher-block-promo.jpg",
      title_color: "blue",
      links: [
        { text: "Pay and benefits", url: "/life-as-a-teacher/pay-and-benefits" },
        { text: "Why teach", url: "/life-as-a-teacher/why-teach" },
        { text: "Teaching as a career", url: "/life-as-a-teacher/teaching-as-a-career" },
        { text: "Explore subjects you could teach", url: "/life-as-a-teacher/explore-subjects" },
        { text: "Age groups and specialisms", url: "/life-as-a-teacher/age-groups-and-specialisms" },
        { text: "Change to a career in teaching", url: "/life-as-a-teacher/change-careers" },
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
