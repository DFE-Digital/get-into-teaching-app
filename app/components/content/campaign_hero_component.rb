module Content
  class CampaignHeroComponent < ViewComponent::Base
    attr_accessor :title, :colour, :background_colour

    def initialize(title:, colour:, image:, background_colour: nil)
      super

      @title = title
      @colour = colour
      @image = image
      @background_colour = background_colour
    end

    def header_image
      image_pack_tag(@image, alt: helpers.image_alt(@image)) if @image
    end

    def classes
      %w[campaign-hero].tap do |c|
        c << colour if colour
        c << "bg-#{background_colour}" if background_colour
      end
    end
  end
end
