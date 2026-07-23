module ProviderEvents
  module Steps
    class EventDescription < ::GITWizard::Step
      MAX_WORDS = 300
      MAX_CHARS = MAX_WORDS * 20

      include FunnelTitle

      attribute :event_description
      validates :event_description, presence: true, length: { maximum: MAX_CHARS }, number_of_words: { less_than: MAX_WORDS }
    end
  end
end
