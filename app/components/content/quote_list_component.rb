module Content
  class QuoteListComponent < ViewComponent::Base
    attr_reader :quotes

    def initialize(quotes:)
      super

      @quotes = quotes
    end

  private

    def before_render
      validate!
    end

    def validate!
      quotes.each_with_index do |quote, idx|
        %i[heading text accreditation].each do |required_key|
          error_message = "#{required_key} must be present for quote #{idx + 1}"
          fail(ArgumentError, error_message) if quote[required_key].blank?
        end
      end
    end
  end
end
