class CallsToAction::MailinglistComponent < ViewComponent::Base
  attr_reader :title, :text, :image, :link_text, :link_target, :classes, :border

  def initialize(
    title: "Find out more about getting into teaching",
    text: "Get helpful guidance and support on getting into teaching, including how to get the qualifications you need.",
    image: "images/content/hero-images/geography2.jpg",
    link_text: "Get tailored advice in your inbox",
    link_target: "/mailinglist/signup/name",
    classes: [],
    border: true
  )
    super

    @title = title
    @text = text
    @image = image
    @link_text = link_text
    @link_target = link_target
    @classes = ["mailinglist", *classes].compact.join(" ")
    @border = border
  end
end
