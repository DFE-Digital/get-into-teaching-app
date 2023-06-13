module Callbacks
  module Steps
    class Callback < ::GITWizard::Step
      extend CallbackBookingQuotas

      attribute :first_name, :string
      attribute :last_name, :string
      attribute :email, :string
      attribute :accepted_policy_id, :string
      attribute :candidate_id, :string

      attribute :address_telephone, :string
      attribute :phone_call_scheduled_at, :datetime

      validates :address_telephone, telephone: true, presence: true
      validates :phone_call_scheduled_at, presence: true

      before_validation if: :address_telephone do
        self.address_telephone = address_telephone.to_s.strip.presence
      end

      def can_proceed?
        self.class.callback_booking_quotas.any?
      end

      def candidate_id
        api = GetIntoTeachingApiClient::TeacherTrainingAdviserApi.new
        sign_up = api.matchback_candidate(email: email)
        sign_up.candidate_id
      end
    end
  end
end
