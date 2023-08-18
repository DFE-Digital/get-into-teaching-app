module Feedback
  module Steps
    class SignupExperience < ::GITWizard::Step
      attribute :experience

      def skipped?
        other_step(:signup).skipped?
      end

      def can_proceed?
        true
      end
    end
  end
end
