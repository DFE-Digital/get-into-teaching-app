module ProviderEvents
  module Steps
    class EventDescription < ::GITWizard::Step
      MAX_WORDS = 300
      MAX_CHARS = MAX_WORDS * 20

      include FunnelTitle
      include ActiveRecord::Normalization
      include ActiveModel::Dirty

      attribute :description
      validates :description, presence: true, length: { maximum: MAX_CHARS }, number_of_words: { less_than: MAX_WORDS }
      normalizes :description, with: ->(field) { field.to_s.squish.presence }
    end
  end
end
