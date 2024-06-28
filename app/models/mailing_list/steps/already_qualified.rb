module MailingList
  module Steps
    class AlreadyQualified < ::GITWizard::Step
      def skipped?
        !other_step("returning_teacher").qualified_to_teach
      end

      def can_proceed?
        false
      end
    end
  end
end
