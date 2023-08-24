module Feedback
  module Steps
    class Purpose < ::GITWizard::Step
      OPTIONS = [
        "Give feedback about the website",
        "Give feedback about signing up for an adviser",
        "Give feedback about signing up for emails",
        "Give feedback about signing up for an event",
      ].freeze

      attribute :topic
      validates :topic, presence: true, inclusion: { in: OPTIONS }
    end
  end
end
