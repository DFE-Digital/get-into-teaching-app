class CallsToAction::RoutesComponent < ViewComponent::Base
  attr_reader :title, :text, :image, :link_text, :link_target, :classes, :border

  def initialize(
    title: "Find your route into teaching",
    text: "An adviser with years of teaching experience can help you to become a teacher. Chat by phone, text, or email as little or often as you need.",
    image: "static/images/routes.png",
    link_text: "Find your route into teaching",
    link_target: "/routes-into-teaching",
    classes: [],
    border: true
  )
    super

    @title = title
    @text = text
    @image = image
    @link_text = link_text
    @link_target = link_target
    @classes = ["routes", *classes].compact.join(" ")
    @border = border
  end
end
