module Content
  class GenericBlockComponent < ViewComponent::Base
    attr_reader :title, :classes

    def initialize(title:, icon_image:, icon_alt:, classes: [])
      @title      = title
      @icon_image = icon_image
      @icon_alt   = icon_alt
      @classes    = classes
    end

    def icon
      tag.div(class: "blocks__icon") do
        image_pack_tag(@icon_image, alt: @icon_alt)
      end
    end
  end
end
