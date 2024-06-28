module Events
  module Steps
    class FurtherDetails < ::GITWizard::Step
      attribute :subscribe_to_mailing_list, :boolean

      validates :subscribe_to_mailing_list, inclusion: { in: :mailing_list_values }

      def can_subscribe_to_mailing_list?
        !already_subscribed_to_mailing_list? && !already_subscribed_to_teacher_training_adviser?
      end

      def skipped?
        !can_subscribe_to_mailing_list?
      end

    private

      def mailing_list_values
        can_subscribe_to_mailing_list? ? [true, false] : [true, false, nil]
      end

      def already_subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end

      def already_subscribed_to_teacher_training_adviser?
        @store["already_subscribed_to_teacher_training_adviser"]
      end
    end
  end
end
