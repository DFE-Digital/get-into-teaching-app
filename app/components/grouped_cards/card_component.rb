module GroupedCards
  class CardComponent < ViewComponent::Base
    attr_reader :data

    def initialize(data)
      super

      @data = data
    end

    def header
      @data["header"]
    end

    def linked_header
      if link
        link_to tag.h4(header), link
      else
        tag.h4 header
      end
    end

    def fields
      @data.without("header", "link")
    end

    def linked_value(value)
      Rinku.auto_link(h(value)).html_safe
    end

    def link
      @data["link"]
    end
  end
end
