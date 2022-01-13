module SubjectSpecific
  class TextBlockWithOneImageComponent < ViewComponent::Base
    attr_reader :heading, :colour

    def initialize(heading:, image_path:, image_alt:, colour: "pink")
      super

      @heading = heading
      @colour = colour
      @image_path = image_path
      @image_alt = image_alt
    end

    def image
      image_pack_tag(@image_path, alt: @image_alt)
    end
  end
end
