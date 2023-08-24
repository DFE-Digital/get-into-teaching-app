module Feedback
  module Steps
    class Signup < ::GITWizard::Step
      OPTIONS = { yes: "1", no: "0" }.freeze

      attribute :successful_visit
      validates :successful_visit, presence: true, inclusion: { in: OPTIONS.values }
      attribute :unsuccessful_visit_explanation
      attribute :rating
      validates :rating, presence: true

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
