class HeaderComponent < ViewComponent::Base
  attr_reader :breadcrumbs, :front_matter

  def initialize(breadcrumbs: false, front_matter: {})
    super

    @breadcrumbs = breadcrumbs
    @front_matter = front_matter
  end
end
