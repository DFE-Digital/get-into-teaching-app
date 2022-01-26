module Cards
  class RendererComponent < ViewComponent::Base
    CARD_COMPONENTS_PATH =
      Rails.root.join("app/components/cards/*_component.rb").freeze
    EXCLUDE_COMPONENTS = %w[renderer].freeze
    DEFAULT_TYPE = Cards::StoryComponent

    attr_reader :card, :page_data

    with_collection_parameter :card

    def initialize(card:, page_data: nil)
      super

      @card_type = card["card_type"].to_s
      @card = card.without("card_type")
      @page_data = page_data
    end

    def card_type_instance
      card_type_class.new(card: card, page_data: page_data)
    end

    def call
      render card_type_instance
    end

    class InvalidComponent < RuntimeError
      def initialize(card_type)
        super "\"#{card_type}\" is not a valid card component"
      end
    end

  private

    def card_type_class
      case normalised_card_type
      when "event", "latestevent"
        Cards::LatestEventComponent
      when *EXCLUDE_COMPONENTS
        raise InvalidComponent, @card_type
      when ""
        DEFAULT_TYPE
      else
        begin
          "::Cards::#{normalised_card_type.camelize}Component".constantize
        rescue NameError
          raise InvalidComponent, @card_type
        end
      end
    end

    def normalised_card_type
      @normalised_card_type ||= normalise_card_type
    end

    def normalise_card_type
      @card_type.underscore.gsub(%r{[^a-z _ ]}, "").gsub(%r{\s+}, "_")
    end
  end
end
