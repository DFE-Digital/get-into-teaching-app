module CallsToAction
  class HomepageComponent < ViewComponent::Base
    attr_accessor :icon, :image, :title, :text, :link

    def initialize(icon:, link_text:, link_target:, image:, title: nil, text: nil)
      super

      @title         = title
      @text          = text
      @image         = image
      @icon_filename = icon

      @link_target = link_target
      @link_text   = link_text
    end

    def before_render
      @icon = icon_element(@icon_filename)
      @link = link_to(@link_text, @link_target, class: "button")
    end

  private

    def image_element(image)
      tag.div(style: %[background-image: url('#{asset_pack_path(image)}')], class: "call-to-action__image")
    end

    def icon_element(icon)
      image_pack_tag("media/images/#{icon}.svg",
                     width: 50,
                     height: 50,
                     alt: "",
                     class: "call-to-action__icon")
    end
  end
end
