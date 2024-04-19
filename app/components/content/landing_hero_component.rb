module Content
  class LandingHeroComponent < ViewComponent::Base
    attr_accessor :title, :colour, :background_colour

    def initialize(title:, colour:, image:, background_colour: nil)
      super

      @title = title
      @colour = colour
      @image = image
      @background_colour = background_colour
    end

    def header_image
      image_pack_tag(@image, **helpers.image_alt_attribs(@image)) if @image
    end

    def classes
      %w[landing-hero].tap do |c|
        c << colour if colour
        c << "bg-#{background_colour}" if background_colour
      end
    end
  end
end
