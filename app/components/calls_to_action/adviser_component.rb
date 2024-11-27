class CallsToAction::AdviserComponent < ViewComponent::Base
  attr_reader :title, :text, :image, :button_text

  def initialize(
    title: "Get free one-to-one support",
    text: "An adviser with years of teaching experience can help you to become a maths teacher. Chat by phone, text, or email as little or often as you need.",
    image: "static/images/adviser-black.png",
    button_text: "Find out more about advisers"
  )
    super

    @title = title
    @text = text
    @image = image
    @button_text = button_text
  end
end
