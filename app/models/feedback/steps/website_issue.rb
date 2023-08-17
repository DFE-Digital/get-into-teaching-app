module Feedback
  module Steps
    class WebsiteIssue < ::GITWizard::Step

      attribute :issue

      def skipped?
        !issue?
      end

      def can_proceed?
        true
      end

      def issue?
        @store['website'] == "Tell us something is not working or needs improving"
      end
    end
  end
end
