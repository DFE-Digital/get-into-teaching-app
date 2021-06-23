module Header
  class ExtraNavigationComponent < ViewComponent::Base
    attr_reader :classes

    def initialize(classes: [])
      @classes = %w[extra-navigation] + classes
    end
  end
end
