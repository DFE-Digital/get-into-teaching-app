module Events
  module Steps
    class FurtherDetails < ::Wizard::Step
      attribute :event_id
      attribute :privacy_policy, :boolean
      attribute :mailing_list, :boolean
      attribute :address_postcode
      attribute :accepted_policy_id

      validates :event_id, presence: true
      validates :privacy_policy, presence: true, acceptance: true
      validates :mailing_list, inclusion: [true, false]
      validates :address_postcode, postcode: { allow_blank: true }

      before_validation if: :address_postcode do
        self.address_postcode = address_postcode.to_s.strip.presence
      end

      before_validation if: :already_subscribed_to_mailing_list? do
        self.mailing_list = true
      end

      def save
        if valid?
          @store["subscribe_to_mailing_list"] = mailing_list == true
        end

        super
      end

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end

      def already_subscribed_to_mailing_list?
        @store["already_subscribed_to_mailing_list"]
      end
    end
  end
end
