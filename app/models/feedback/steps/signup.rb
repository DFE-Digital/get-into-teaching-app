module Feedback
  module Steps
    class Signup < ::GITWizard::Step
      OPTIONS = %w[
        Yes
        No
      ].freeze

      attribute :achieved
      validates :achieved, inclusion: { in: OPTIONS }

      def can_proceed?
        true
      end

      def skipped?
        website?
      end

      def website?
        @store["action"] == "Give feedback about the website"
      end
    end
  end
end
