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
        improving_feedback = @store["value"] == "Give general feedback about the website"
        website_step.skipped? || !!improving_feedback
      end
    end
  end
end
