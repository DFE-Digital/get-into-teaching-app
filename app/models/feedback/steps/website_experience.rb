module Feedback
  module Steps
    class WebsiteExperience < ::GITWizard::Step

      attribute :experience

      def skipped?
        !experience?
      end

      def can_proceed?
        true
      end

      def experience?
        @store['website'] == "Give general feedback about the website"
      end
    end
  end
end
