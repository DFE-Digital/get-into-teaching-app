module Content
  class LandingHeroFullwidthComponent < ViewComponent::Base
    attr_reader :image

    include ContentHelper

    def initialize(image:)
      super
      @image = image
    end

    def header_image
      image_pack_tag(@image, **helpers.image_alt_attribs(@image)) if @image
    end
  end
end
