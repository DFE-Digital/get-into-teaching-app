module Content
  class GenericBlockComponent < ViewComponent::Base
    attr_reader :title, :classes

    def initialize(title:, icon_image:, icon_alt:, icon_size: nil, classes: [])
      super

      @title      = title
      @icon_image = icon_image
      @icon_alt   = icon_alt
      @icon_size  = icon_size
      @classes    = classes
    end

    def icon
      tag.div(class: "blocks__icon") do
        image_pack_tag(@icon_image, alt: @icon_alt, size: @icon_size)
      end
    end
  end
end
