module Content
  class QuoteWithImageComponent < ViewComponent::Base
    attr_reader :title, :text, :image, :heading, :color

    def initialize(title:, text:, image: nil, heading: :m, color: "pink")
      super

      @title = title
      @text = text
      @image = image
      @heading = heading
      @color = color
    end

    def image
      image_pack_tag(@image, **helpers.image_alt_attribs(@image)) if @image
    end

    def heading_classes
      %w[].tap do |c|
        c << "heading-#{heading}"
        c << "heading--box-#{color}" unless color == "transparent"
      end
    end
  end
end

