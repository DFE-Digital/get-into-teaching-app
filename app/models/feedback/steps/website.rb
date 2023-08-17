module Feedback
  module Steps
    class Website < ::GITWizard::Step
      OPTIONS = [
        "Give general feedback about the website",
        "Tell us something is not working or needs improving",
      ].freeze

      attribute :website
      validates :website, inclusion: { in: OPTIONS }

      def skipped?
        !website?
      end

      def website?
        @store["action"] == "Give feedback about the website"
      end
    end
  end
end
