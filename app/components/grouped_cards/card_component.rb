module GroupedCards
  class CardComponent < ViewComponent::Base
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def header
      @data["header"]
    end

    def fields
      @data.without("header")
    end

    def linked_value(value)
      Rinku.auto_link(h(value)).html_safe
    end
  end
end
