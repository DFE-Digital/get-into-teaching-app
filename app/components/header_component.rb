class HeaderComponent < ViewComponent::Base
  attr_reader :breadcrumbs, :front_matter

  def initialize(front_matter = {})
    super

    @breadcrumbs = front_matter.with_indifferent_access["breadcrumbs"] != false
    @front_matter = front_matter
  end
end
