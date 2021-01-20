module GroupedCards
  class ListingComponent < ViewComponent::Base
    def initialize(data)
      @data = data
    end

    def regions
      @data.keys
    end

    def group_link_anchor(group)
      "group--" + group.parameterize
    end

    def providers(region)
      @data[region]
    end
  end
end
