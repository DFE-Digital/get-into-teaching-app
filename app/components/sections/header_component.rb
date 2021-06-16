module Sections
  class HeaderComponent < ViewComponent::Base
    attr_reader :front_matter

    def initialize(front_matter: nil)
      @front_matter = front_matter # temporary - make this a slot
    end
  end
end
