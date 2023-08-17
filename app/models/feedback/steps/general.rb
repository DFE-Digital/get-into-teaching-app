module Feedback
  module Steps
    class General < ::GITWizard::Step

      OPTIONS = [
        "Yes",
        "No",
      ].freeze

      attribute :achieved
      validates :achieved, inclusion: { in: OPTIONS }

      def skipped?
        website?
      end

      def website?
        @store["action"] == "Give feedback about the website"
      end
    end
  end
end
