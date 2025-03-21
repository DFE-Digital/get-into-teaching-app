module CallsToAction
  class MailinglistBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Get personalised updates",
      image: "mailing-list-block-promo.jpg",
      title_color: "yellow",
      text: "Get free guidance and support on getting into teaching, including learning more about the benefits of a career in teaching.",
      link_text: "Get tailored advice in your inbox",
      link_target: "/mailinglist/signup/name"
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
