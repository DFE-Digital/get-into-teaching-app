module MailingList
  module Steps
    class Contact < ::Wizard::Step
      attribute :telephone
      attribute :accept_privacy_policy, :boolean
      attribute :accepted_policy_id

      validates :telephone, telephone: true
      validates :accept_privacy_policy, acceptance: true, allow_nil: false

      before_validation if: :telephone do
        self.telephone = telephone.to_s.strip.presence
      end

      def save
        if valid?
          @store["subscribe_to_events"] = true
        end

        super
      end

      def latest_privacy_policy
        @latest_privacy_policy ||= GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
      end
    end
  end
end
