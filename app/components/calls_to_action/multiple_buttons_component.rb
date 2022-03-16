module CallsToAction
  class MultipleButtonsComponent < ViewComponent::Base
    attr_accessor :icon, :title, :links

    def initialize(icon:, title:, links:)
      super

      @title         = title
      @link_data     = links
      @icon_filename = icon
    end

    def before_render
      @icon  = icon_element(@icon_filename)
      @links = @link_data.map { |text, href| link_to(text, href) }
    end

  private

    def icon_element(icon)
      image_pack_tag("media/images/#{icon}.svg",
                     width: 50,
                     height: 50,
                     alt: "",
                     class: "call-to-action__icon")
    end
  end
end
