module Content
  class GenericBlockComponent < ViewComponent::Base
    attr_reader :title, :classes

    include ContentHelper

    def initialize(title:, icon_image:, icon_size: nil, classes: [])
      super

      @title      = substitute_values(title)
      @icon_image = icon_image
      @icon_size  = icon_size
      @classes    = classes
    end

    def icon
      tag.div(class: "blocks__icon") do
        image_pack_tag(@icon_image, size: @icon_size, **helpers.image_alt_attribs_for_text(""))
      end
    end
  end
end
