module GroupedCards
  class ListingComponent < ViewComponent::Base
    def initialize(data)
      @data = data
    end

    def regions
      @data.keys
    end

    def region_link_anchor(region)
      region.downcase.gsub %r{[^a-z0-9]+}, "-"
    end

    def providers(region)
      @data[region]
    end
  end
end
