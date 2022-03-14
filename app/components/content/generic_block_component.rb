module Content
  class GenericBlockComponent < ViewComponent::Base
    attr_reader :title, :classes

    def initialize(title:, icon_image:, icon_size: nil, classes: [])
      super

      @title      = title
      @icon_image = icon_image
      @icon_size  = icon_size
      @classes    = classes
    end

    def icon
      tag.div(class: "blocks__icon") do
        image_pack_tag(@icon_image, size: @icon_size, alt: "")
      end
    end
  end
end
