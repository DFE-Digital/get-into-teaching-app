module SubjectSpecific
  class TextBlockWithOneImageComponent < ViewComponent::Base
    attr_reader :heading, :colour

    def initialize(heading:, image_1_path:, image_1_alt:, colour: "pink")
      super

      @heading = heading
      @colour = colour
      @image_1_path = image_1_path
      @image_1_alt = image_1_alt
    end
  end
end
