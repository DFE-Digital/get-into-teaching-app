module Feedback
  module Steps
    class Signup < ::GITWizard::Step
      OPTIONS = { yes: "Yes", no: "No" }.freeze

      attribute :successful_visit
      validates :successful_visit, inclusion: { in: OPTIONS.values }
      attribute :unsuccessful_visit_explanation
      attribute :rating

      def can_proceed?
        true
      end

      def skipped?
        website?
      end

      def website?
        @store["topic"] == "Give feedback about the website"
      end
    end
  end
end
