module Callbacks
  module Steps
    class Callback < ::GITWizard::Step
      extend CallbackBookingQuotas

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
    end
  end
end
