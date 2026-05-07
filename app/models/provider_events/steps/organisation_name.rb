module ProviderEvents
  module Steps
    class OrganisationName < ::GITWizard::Step
      include FunnelTitle

      attribute :organisation_name
      validates :organisation_name, presence: true, length: { maximum: 200 }
    end
  end
end
