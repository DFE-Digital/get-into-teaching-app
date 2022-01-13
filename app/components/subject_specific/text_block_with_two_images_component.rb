module SubjectSpecific
  class TextBlockWithTwoImagesComponent < ViewComponent::Base
    attr_reader :heading, :colour

    def initialize(heading:, image_1_path:, image_1_alt:, image_2_path:, image_2_alt:, colour: "pink")
      super

      @heading = heading
      @colour = colour
      @image_1_path = image_1_path
      @image_1_alt = image_1_alt
      @image_2_path = image_2_path
      @image_2_alt = image_2_alt
    end

    def image_1
      image_pack_tag(@image_1_path, alt: @image_1_alt)
    end

    def image_2
      image_pack_tag(@image_2_path, alt: @image_2_alt)
    end
  end
end
