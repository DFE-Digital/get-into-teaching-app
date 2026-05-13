module CallsToAction
  class MailinglistBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :image_classes, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Get personalised guidance2",
      image: "paper-plane.svg",
      image_classes: "image-background gitbluetint",
      title_color: "gitbluepastel",
      text: "Sign up for free guidance and support on getting into teaching.",
      link_text: "Get advice in your inbox",
      link_target: "/mailinglist/signup/name"
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
