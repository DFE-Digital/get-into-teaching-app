module Feedback
  module Steps
    class Website < ::GITWizard::Step
      OPTIONS = [
        "Give general feedback about the website",
        "Tell us something is not working or needs improving",
      ].freeze

      attribute :value
      validates :value, inclusion: { in: OPTIONS }

      def can_proceed?
        true
      end

      def skipped?
        !website?
      end

      def website?
        @store["area"] == "Give feedback about the website"
      end
    end
  end
end
