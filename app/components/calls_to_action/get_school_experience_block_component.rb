module CallsToAction
  class GetSchoolExperienceBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Get School Experience",
      image: "get-school-experience-block-promo.jpg",
      title_color: "green",
      text: "Use our service to search for and organise school experience in England.",
      link_text: "Search for school experience",
      link_target: "https://schoolexperience.education.gov.uk/"
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
