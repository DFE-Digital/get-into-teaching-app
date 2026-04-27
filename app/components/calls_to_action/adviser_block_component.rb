module CallsToAction
  class AdviserBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :image_background, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Get a free adviser",
      image: "adviser-black.png",
      title_color: "gitbluepastel",
      image_background: "gitbluetint",
      text: "An adviser with years of teaching experience can help you become a teacher.",
      link_text: "Find out about advisers",
      link_target: "/teacher-training-advisers"
    )
      super
      @title = title
      @image = image
      @image_background = image_background
      @title_color = title_color
      @text = text
      @link_text = link_text
      @link_target = link_target
    end
  end
end
