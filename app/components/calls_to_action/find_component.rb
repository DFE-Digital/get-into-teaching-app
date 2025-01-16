module CallsToAction
  class FindComponent < ViewComponent::Base
    attr_accessor :icon, :title, :text, :link

    def initialize(icon: "icon-search-black", link_text: "Find your teacher training course", link_target: "https://find-teacher-training-courses.service.gov.uk/", title: "Find your teacher training course", text: "Take a look at the different teacher training courses available.", hide_on_mobile: false, hide_on_tablet: false, hide_on_desktop: false)
      super

      @icon_filename = icon
      @title         = title
      @text          = text
      @link_text     = link_text
      @link_target   = link_target

      @hide_on_mobile  = hide_on_mobile
      @hide_on_tablet  = hide_on_tablet
      @hide_on_desktop = hide_on_desktop
    end

    def before_render
      fail(ArgumentError, "a title or text\/content must be present") if [title, text, content].all?(&:nil?)

      @icon = icon_element(@icon_filename)
      @link = link_to(@link_text, @link_target, class: "button", role: "button", "data-promo-type": "find") if @link_text.present?
    end

  private

    def icon_element(icon)
      image_pack_tag("static/images/#{icon}.svg",
                     width: 50,
                     height: 50,
                     **helpers.image_alt_attribs_for_text(""),
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
