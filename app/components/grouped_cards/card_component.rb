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
      @data.without("header", "link", "status", "extension", "international_phone")
    end

    def linked_value(field, value)
      tags = []

      if field == "telephone" && value.present?
        tags << if @data["international_phone"].present?
                  # Although we present the national telephone number, we need to use the
                  # international_phone value in the URL to support overseas visitors
                  tag.span { link_to(value, "tel:#{@data['international_phone']}") }
                else
                  tag.span { link_to(value, "tel:#{value}") }
                end
        # add extension here
        if @data["extension"].present?
          tags << tag.span(class: "extension") { @data["extension"] }
        end
      else
        tags << tag.span { Rinku.auto_link(h(value)).html_safe }
      end
      safe_join tags
    end

    def link
      @data["link"]
    end
  end
end
