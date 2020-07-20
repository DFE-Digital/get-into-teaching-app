module MailingList
  module Steps
    class Contact < ::Wizard::Step
      attribute :telephone
      attribute :callback_information
      attribute :accept_privacy_policy, :boolean

      validates :telephone, telephone: true
      validates :callback_information, presence: true, if: -> { telephone.present? }
      validates :callback_information, number_of_words: { less_than: 200 }
      validates :accept_privacy_policy, acceptance: true, allow_nil: false

      before_validation if: :telephone do
        self.telephone = telephone.to_s.strip.presence
      end

      before_validation if: :callback_information do
        self.callback_information = callback_information.to_s.strip.presence
      end

      def save
        if valid?
          # TODO: ensure this is the policy we display to the user
          accepted_policy = GetIntoTeachingApiClient::PrivacyPoliciesApi.new.get_latest_privacy_policy
          @store["accepted_policy_id"] = accepted_policy.id
          @store["subscribe_to_mailing_list"] = true
        end

        super
      end
    end
  end
end
