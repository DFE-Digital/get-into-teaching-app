module CallsToAction
  class MultipleButtonsComponent < ViewComponent::Base
    attr_accessor :icon, :title, :links

    def initialize(icon:, title:, links:)
      @icon  = icon_element(icon)
      @title = title
      @links = links.map { |text, href| link_to(tag.span(text), href) }
    end

  private

    def icon_element(icon)
      image_pack_tag("media/images/#{icon}.svg",
                     width: 50,
                     height: 50,
                     alt: "#{icon} icon",
                     class: "call-to-action__icon")
    end
  end
end
