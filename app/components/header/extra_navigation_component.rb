module Header
  class ExtraNavigationComponent < ViewComponent::Base
    attr_reader :classes

    def initialize(classes: [])
      super

      @classes = %w[extra-navigation] + classes
    end
  end
end
