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

    def status
      @data["status"]
    end

    def linked_header
      if link
        link_to tag.h4(header), link
      else
        tag.h4 header
      end
    end

    def fields
      @data.without("header", "link", "status", "international_phone")
    end

    # def linked_value(value)
    #   Rinku.auto_link(h(value)).html_safe
    # end

    def linked_value(field, value)
      if field == "telephone" && value.present?
        if @data["international_phone"].present?
          # Although we present the national telephone number, we need to use the
          # international_phone value in the URL to support overseas visitors
          link_to(value, "tel:#{@data['international_phone']}")
        else
          link_to(value, "tel:#{value}")
        end
      else
        Rinku.auto_link(h(value)).html_safe
      end
    end

    def link
      @data["link"]
    end
  end
end
