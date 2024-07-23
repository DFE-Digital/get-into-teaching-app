module Content
  class LandingHeroComponent < ViewComponent::Base
    attr_accessor :colour, :image, :title, :title_paragraph

    include ContentHelper

    def initialize(colour:, image:, title:, title_paragraph: nil)
      super
      @colour = colour
      @image = image
      @title = substitute_values(title)
      @title_paragraph = substitute_values(title_paragraph)
    end

    def header_image
      image_pack_tag(@image, **helpers.image_alt_attribs(@image)) if @image
    end

    def show_title_paragraph?
      @title_paragraph.present?
    end

    def classes
      %w[landing-hero].tap do |c|
        c << colour if colour
      end
    end
  end
end
