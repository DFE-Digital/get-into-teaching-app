module MailingList
  module Steps
    class AlreadyQualified < ::GITWizard::Step
      include FunnelTitle

      def skipped?
        !other_step("returning_teacher").qualified_to_teach
      end

      def can_proceed?
        false
      end

      def title_attribute
        :title
      end

      def skip_title_suffix?
        true
      end
    end
  end
end
