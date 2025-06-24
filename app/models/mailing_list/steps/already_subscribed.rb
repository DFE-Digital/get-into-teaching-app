module MailingList
  module Steps
    class AlreadySubscribed < ::GITWizard::Step
      include FunnelTitle

      def skipped?
        !subscribed_to_mailing_list?
      end

      def can_proceed?
        false
      end

      def subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end

      def title_attribute
        :title
      end
    end
  end
end
