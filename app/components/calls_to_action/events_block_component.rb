module CallsToAction
  class EventsBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Attend a training provider event",
      image: "events-block-promo.jpg",
      title_color: "yellow",
      text: "Speak to teacher training providers at an event.",
      link_text: "Find an event",
      link_target: "/events"
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
