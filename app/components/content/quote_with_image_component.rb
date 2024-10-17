module Content
  class QuoteWithImageComponent < ViewComponent::Base
    attr_reader :title, :text, :image_path, :heading, :heading_color, :quotes, :background_color

    def initialize(title:, text:, image_path: nil, heading: :m, heading_color: "pink", background_color: "blue", quotes: true)
      super

      @title = title
      @text = text
      @image_path = image_path
      @heading = heading
      @heading_color = heading_color
      @quotes = quotes
      @background_color = background_color
    end

    def image
      image_pack_tag(@image_path, **helpers.image_alt_attribs(@image_path)) if @image_path
    end
  end
end
