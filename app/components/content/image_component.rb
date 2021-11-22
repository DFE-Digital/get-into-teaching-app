module Content
  class ImageComponent < ViewComponent::Base
    attr_reader :path, :alt

    def initialize(path:, alt:)
      super

      @path = path
      @alt  = alt
    end

    def render?
      path.present?
    end

    def call
      helpers.image_pack_tag(path, alt: alt)
    end
  end
end
