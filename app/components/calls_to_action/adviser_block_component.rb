module CallsToAction
  class AdviserBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :image_classes, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Get a free adviser",
      image: "communication-icon.svg",
      title_color: "gitbluepastel",
      image_classes: "image-background gitbluetint padding-small",
      text: "An adviser with years of teaching experience can help you become a teacher.",
      link_text: "Find out about advisers",
      link_target: "/teacher-training-advisers"
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
