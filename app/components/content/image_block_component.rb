module Content
  class ImageBlockComponent < ViewComponent::Base
    attr_reader :title, :image_path

    def initialize(title:, image_path:)
      super

      @title = title
      @image_path = image_path
    end

    def image
      helpers.image_pack_tag(image_path, alt: helpers.image_alt(image_path))
    end
  end
end
