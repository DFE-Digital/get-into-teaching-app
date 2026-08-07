module ProviderEvents
  module Steps
    class OrganisationName < ::GITWizard::Step
      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :organisation_name
      validates :organisation_name, presence: true, length: { maximum: 200 }
      normalizes :organisation_name, with: ->(field) { field.to_s.squish.presence }
    end
  end
end
