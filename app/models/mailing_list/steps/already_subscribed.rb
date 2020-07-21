module MailingList
  module Steps
    class AlreadySubscribed < ::Wizard::Step
      def skipped?
        !@store["already_subscribed_to_mailing_list"]
      end

      def can_proceed?
        false
      end
    end
  end
end
