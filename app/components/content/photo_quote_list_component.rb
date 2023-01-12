module Content
  class PhotoQuoteListComponent < ViewComponent::Base
    COLORS = %w[pink green blue yellow].freeze
    REQUIRED_QUOTE_KEYS = %i[image heading text accreditation].freeze

    attr_reader :quotes, :colors, :numbered

    def initialize(quotes, colors: COLORS, numbered: true)
      super

      @quotes = quotes
      @colors = colors
      @numbered = numbered
    end

    def item_color(index)
      colors[index % colors.count]
    end

    def classes
      %w[photo-quote-list].tap do |c|
        c << "photo-quote-list--numbered" if numbered
      end
    end

  private

    def before_render
      validate!
    end

    def validate!
      quotes.each_with_index do |quote, idx|
        REQUIRED_QUOTE_KEYS.each do |required_key|
          error_message = "#{required_key} must be present for quote #{idx + 1}"
          fail(ArgumentError, error_message) if quote[required_key].blank?
        end
      end
    end
  end
end
