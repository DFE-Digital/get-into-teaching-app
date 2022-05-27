class HeaderComponent < ViewComponent::Base
  attr_reader :breadcrumbs

  def initialize(breadcrumbs: false)
    super

    @breadcrumbs = breadcrumbs
  end
end
