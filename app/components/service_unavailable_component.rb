class ServiceUnavailableComponent < ViewComponent::Base
  def initialize(service_type:)
    super

    @service_type = service_type
  end
end
