class FooterComponent < ViewComponent::Base
  def initialize(front_matter = {})
    super

    @front_matter = front_matter
  end
end
