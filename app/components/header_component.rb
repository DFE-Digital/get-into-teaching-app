class HeaderComponent < ViewComponent::Base
  renders_one :hero, Header::HeroComponent
  renders_one :above_hero

  attr_reader :breadcrumbs

  def initialize(breadcrumbs: false)
    super

    @breadcrumbs = breadcrumbs
  end
end
