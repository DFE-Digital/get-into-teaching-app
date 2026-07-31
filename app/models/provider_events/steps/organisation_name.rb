module ProviderEvents
  module Steps
    class OrganisationName < ::GITWizard::Step
      include FunnelTitle
      include SanitiseField

      attribute :organisation_name
      validates :organisation_name, presence: true, length: { maximum: 200 }

      before_validation -> { sanitise_field :organisation_name }
    end
  end
end
