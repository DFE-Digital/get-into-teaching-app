module Content
  class ImageComponent < ViewComponent::Base
    attr_reader :path

    def initialize(path:)
      super

      @path = path
    end

    def render?
      path.present?
    end

    def call
      helpers.image_pack_tag(path, **helpers.image_alt_attribs(path))
    end
  end
end
