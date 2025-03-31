module CallsToAction
  class RoutesBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Find your route into teaching",
      image: "routes-block-promo.jpg",
      title_color: "yellow",
      text: "Answer 3 questions and find routes into teaching based on your circumstances.",
      link_text: "Find a route",
      link_target: "/routes-into-teaching"
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
