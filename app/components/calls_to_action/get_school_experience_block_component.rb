module CallsToAction
  class GetSchoolExperienceBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :image_classes, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Get school experience",
      image: "icon-building.svg",
      image_classes: "image-background gitgreentint padding-medium",
      title_color: "gitgreenpastel",
      text: "Experience life as a teacher in a school in England.",
      link_text: "Search for school experience",
      link_target: "https://schoolexperience.education.gov.uk/"
    )
      super
      @title = title
      @image = image
      @image_classes = image_classes
      @title_color = title_color
      @text = text
      @link_text = link_text
      @link_target = link_target
    end
  end
end
