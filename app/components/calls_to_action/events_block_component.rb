module CallsToAction
  class EventsBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Attend a Get Into Teaching event",
      image: "events-block-promo.jpg",
      title_color: "yellow",
      text: "Speak to teachers, expert advisers and teacher training providers at an in-person or online event.",
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
