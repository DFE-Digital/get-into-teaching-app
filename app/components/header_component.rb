class HeaderComponent < ViewComponent::Base
  renders_one :hero, Header::HeroComponent

  attr_reader :front_matter

  def initialize(front_matter: nil)
    @front_matter = front_matter # temporary - make this a slot
  end
end
