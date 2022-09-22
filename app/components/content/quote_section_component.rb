module Content
  class QuoteSectionComponent < ViewComponent::Base
    renders_one :quote, QuoteComponent

    attr_reader :title, :image, :reverse

    def initialize(title:, image:, reverse: false)
      super

      @title = title
      @image = image
      @reverse = reverse

      fail(ArgumentError, "title must be present") if title.blank?
      fail(ArgumentError, "image must be present") if image.blank?
    end

    def classes
      %w[quote-section].tap do |c|
        c << "quote-section--reverse" if reverse
      end
    end

    def picture
      helpers.image_pack_tag(@image, alt: helpers.image_alt(@image))
    end
  end
end
