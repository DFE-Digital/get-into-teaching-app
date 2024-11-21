module CallsToAction
  class HomepageComponent < ViewComponent::Base
    attr_accessor :icon, :image, :title, :text, :link, :caption, :badge_text

    def initialize(icon:, link_text:, link_target:, image:, title: nil, caption: nil, text: nil, badge_text: nil)
      super

      @title = title
      @badge_text = badge_text
      @caption = caption
      @text = text
      @image = image
      @icon_filename = icon

      @link_target = link_target
      @link_text   = link_text
    end

    def before_render
      @icon = icon_element(@icon_filename)
      @link = link_to(@link_text, @link_target, class: "button", role: "button")
    end

  private

    def image_element(image)
      tag.div(style: %[background-image: url('#{asset_pack_path(image)}')], class: "call-to-action__image") do
        tag.div(tag.span(helpers.safe_html_format(badge_text)), class: "badge badge--bordered badge--fixed-80") if badge_text.present?
      end
    end

    def icon_element(icon)
      image_pack_tag("static/images/#{icon}.svg",
                     width: 50,
                     height: 50,
                     **helpers.image_alt_attribs_for_text(""),
                     class: "call-to-action__icon")
    end
  end
end
