module CallsToAction
  class FindBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Find your teacher training course",
      image: "find-block-promo.jpg",
      title_color: "green",
      text: "Take a look at the different teacher training courses available.",
      link_text: "Find teacher training courses",
      link_target: "https://find-teacher-training-courses.service.gov.uk"
    )
      super
      @title = title
      @image = image
      @title_color = title_color
      @text = text
      @link_text = link_text
      @link_target = link_target
    end
  end
end
