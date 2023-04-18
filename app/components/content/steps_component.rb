module Content
  class StepsComponent < ViewComponent::Base
    attr_reader :steps, :numeric

    def initialize(steps:, numeric: true)
      super

      @numeric = numeric
      @steps = steps
    end

    def list_tag(options = nil, &block)
      content_tag(numeric ? :ol : :ul, capture(&block), options)
    end
  end
end
