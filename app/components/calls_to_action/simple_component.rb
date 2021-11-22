module CallsToAction
  class SimpleComponent < ViewComponent::Base
    attr_accessor :icon, :title, :text, :link

    def initialize(icon:, link_text:, link_target:, title: nil, text: nil, hide_on_mobile: false, hide_on_tablet: false, hide_on_desktop: false)
      super

      @icon_filename = icon
      @title         = title
      @text          = text
      @link_text     = link_text
      @link_target   = link_target

      @hide_on_mobile  = hide_on_mobile
      @hide_on_tablet  = hide_on_tablet
      @hide_on_desktop = hide_on_desktop

      fail(ArgumentError, "a title or text must be present") if title.nil? && text.nil?
    end

    def before_render
      @icon = icon_element(@icon_filename)
      @link = link_to(@link_text, @link_target, class: "button")
    end

  private

    def icon_element(icon)
      image_pack_tag("media/images/#{icon}.svg",
                     width: 50,
                     height: 50,
                     alt: "#{icon} icon",
                     class: "call-to-action__icon")
    end

    def responsive_classes
      [].tap do |classes|
        classes << "hide-on-mobile"  if @hide_on_mobile
        classes << "hide-on-tablet"  if @hide_on_tablet
        classes << "hide-on-desktop" if @hide_on_desktop
      end
    end
  end
end
