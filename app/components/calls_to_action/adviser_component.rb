class CallsToAction::AdviserComponent < ViewComponent::Base
  attr_reader :title, :text, :image, :link_text, :link_target, :classes, :border

  def initialize(
    title: "Get free one-to-one support",
    text: "An adviser with years of teaching experience can help you to become a teacher. Chat by phone, text, or email as little or often as you need.",
    image: "static/images/adviser-black.png",
    link_text: "Find out more about advisers",
    link_target: "/teacher-training-advisers",
    classes: [],
    border: true
  )
    super

    @title = title
    @text = text
    @image = image
    @link_text = link_text
    @link_target = link_target
    @classes = ["adviser", *classes].compact.join(" ")
    @border = border
  end
end
