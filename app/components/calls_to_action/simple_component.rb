module CallsToAction
  class SimpleComponent < ViewComponent::Base
    attr_accessor :icon, :title, :text, :link

    def initialize(icon:, title: nil, text: nil, link_text:, link_target:)
      @icon  = icon_element(icon)
      @title = title
      @text  = text
      @link  = link_to(tag.span(link_text), link_target)

      fail(ArgumentError, "a title or text must be present") if title.nil? && text.nil?
    end

  private

    def icon_element(icon)
      image_tag(
        asset_pack_path("media/images/calls-to-action/#{icon}.svg"),
        width: 50,
        height: 50,
        alt: "#{icon} icon",
        class: "call-to-action__icon",
      )
    end
  end
end
