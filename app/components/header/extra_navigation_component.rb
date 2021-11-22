module Header
  class ExtraNavigationComponent < ViewComponent::Base
    attr_reader :classes, :search_input_id

    def initialize(search_input_id:, classes: [])
      @classes         = %w[extra-navigation] + classes
      @search_input_id = search_input_id
    end
  end
end
