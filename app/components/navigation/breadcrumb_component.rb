module Navigation
  class BreadcrumbComponent < ViewComponent::Base
    attr_accessor :under_hero

    def initialize(under_hero: false)
      @under_hero = under_hero
    end
  end
end
