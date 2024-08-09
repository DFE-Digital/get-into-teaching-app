module Content
  class ImageBlockComponent < ViewComponent::Base
    attr_reader :title, :image_path

    include ContentHelper

    def initialize(title:, image_path:)
      super

      @title = substitute_values(title)
      @image_path = image_path
    end

    def image
      helpers.image_pack_tag(image_path, **helpers.image_alt_attribs(image_path))
    end
  end
end
