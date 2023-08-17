module Feedback
  module Steps
    class Satisfied < ::GITWizard::Step
      OPTIONS = [
        "Very satisfied",
        "Somewhat satisfied",
        "Neither satisfied nor dissatisfied",
        "Somewhat dissatisfied",
        "Very dissatisfied",
      ].freeze

      attribute :state
      validates :state, inclusion: { in: OPTIONS }

      def skipped?
        !website?
      end

      def website?
        @store["action"] == "Give feedback about the website"
      end
    end
  end
end
