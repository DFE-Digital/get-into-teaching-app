module Feedback
  module Steps
    class WebsiteExperience < ::GITWizard::Step
      attribute :experience
      attribute :state

      def can_proceed?
        true
      end

      def skipped?
        website_step = other_step(:website)
        general_feedback = @store["value"] == "Give general feedback about the website"

        website_step.skipped? || !general_feedback
      end
    end
  end
end
