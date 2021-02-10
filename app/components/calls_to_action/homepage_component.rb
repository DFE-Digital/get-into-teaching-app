module CallsToAction
  class HomepageComponent < ViewComponent::Base
    attr_accessor :icon, :image, :title, :link

    def initialize(icon:, title: nil, link_text:, link_target:, image:)
      @title = title
      @link  = link_to(tag.span(link_text), link_target)
      @icon  = icon_element(icon)
      @image = image_element(image)
    end

  private

    def image_element(image)
      tag.div(style: %[background-image: url('#{image}')], class: "call-to-action__image")
    end

    def icon_element(icon)
      img = image_pack_tag("media/images/#{icon}.svg",
                           width: 50,
                           height: 50,
                           alt: "#{icon} icon",
                           class: "call-to-action__icon")

      tag.div(img, class: "call-to-action__icon__box")
    end
  end
end
