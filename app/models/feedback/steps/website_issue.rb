module Feedback
  module Steps
    class WebsiteIssue < ::GITWizard::Step
      attribute :unsuccessful_visit_explanation
      attribute :rating

      def can_proceed?
        true
      end

      def skipped?
        website_step = other_step(:website)
        improving_feedback = @store["value"] == "Tell us something is not working or needs improving"
        website_step.skipped? || !!improving_feedback
      end
    end
  end
end
