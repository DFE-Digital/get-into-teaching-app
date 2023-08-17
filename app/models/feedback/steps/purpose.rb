module Feedback
  module Steps
    class Purpose < ::GITWizard::Step
      OPTIONS = [
        "Give feedback about the website",
        "Give feedback about signing up for an adviser ",
        "Give feedback about signing up for an emails",
        "Give feedback about signing up for an event ",
      ].freeze

      attribute :action
      validates :action, inclusion: { in: OPTIONS }

      # def can_proceed?
      #   true
      # end
    end
  end
end
