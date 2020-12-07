module Cards
  class RendererComponent < ViewComponent::Base
    CARD_COMPONENTS_PATH =
      Rails.root.join("app/components/cards/*_component.rb").freeze
    EXCLUDE_COMPONENTS = %w[renderer].freeze
    DEFAULT_TYPE = Cards::StoryComponent

    attr_reader :card, :page_data
    with_collection_parameter :card

    class << self
      def components
        @components ||= enumerate_components.without(*EXCLUDE_COMPONENTS)
      end

    private

      def list_components
        Dir[CARD_COMPONENTS_PATH]
      end

      def enumerate_components
        list_components.map.with_object({}) do |filename, hash|
          card_name = File.basename(filename).gsub(%r{\_component.rb\Z}, "")
          normalised_name = card_name.gsub %r{[^a-z]}, ""

          hash[normalised_name] =
            "Cards::#{card_name.camelize}Component".constantize
        end
      end
    end

    def initialize(card:, page_data: nil)
      @card_type = card["card_type"] || "Story"
      @card = card.without("card_type")
      @page_data = page_data
    end

    def card_type_instance
      card_type_class.new(card: card, page_data: page_data)
    end

    def call
      render card_type_instance
    end

  private

    def card_type_class
      case normalised_card_type
      when "event"
        Cards::LatestEventComponent
      else
        self.class.components[normalised_card_type] || DEFAULT_TYPE
      end
    end

    def normalised_card_type
      @normalised_card_type ||= @card_type.downcase.gsub(%r{[^a-z]}, "")
    end
  end
end
