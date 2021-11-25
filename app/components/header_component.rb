class HeaderComponent < ViewComponent::Base
  renders_one :hero, Header::HeroComponent

  attr_reader :breadcrumbs

  def initialize(breadcrumbs: false)
    super

    @breadcrumbs = breadcrumbs
  end
end
