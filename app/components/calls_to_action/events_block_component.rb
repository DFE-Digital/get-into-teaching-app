module CallsToAction
  class EventsBlockComponent < ViewComponent::Base
    attr_reader :title, :image, :image_classes, :title_color, :text, :link_text, :link_target

    def initialize(
      title: "Attend a training provider event2",
      image: "icon-calendar.svg",
      image_classes: "image-background gitbluetint padding-large",
      title_color: "gitbluepastel",
      text: "Speak to teacher training providers at an event.",
      link_text: "Find an event",
      link_target: "/events"
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
