module ProviderEvents
  module Steps
    class OrganisationName < ::GITWizard::Step
      MAX_CHARS = 300

      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :organisation_name
      validates :organisation_name, presence: true, length: { maximum: MAX_CHARS }
      normalizes :organisation_name, with: ->(field) { field.to_s.squish.presence }
    end
  end
end
