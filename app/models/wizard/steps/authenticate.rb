module Wizard
  module Steps
    class Authenticate < ::DFEWizard::Step
      include ActiveModel::Dirty

      IDENTITY_ATTRS = %i[email first_name last_name date_of_birth].freeze

      attribute :timed_one_time_password

      validates :timed_one_time_password, presence: true, length: { is: 6, message: :invalid },
                                          format: { with: /\A[0-9]*\z/, message: :invalid }
      validate :timed_one_time_password_is_correct, if: :perform_api_check?

      before_validation if: :timed_one_time_password do
        self.timed_one_time_password = timed_one_time_password.to_s.strip
      end

      def skipped?
        @store["authenticate"] != true
      end

      def export
        {}
      end

      def candidate_identity_data
        @store.fetch(IDENTITY_ATTRS).compact.transform_keys do |k|
          k.camelize(:lower).to_sym
        end
      end

    private

      def perform_api_check?
        timed_one_time_password_valid? && !@wizard.access_token_used?
      end

      def timed_one_time_password_valid?
        self.class.validators_on(:timed_one_time_password).each do |validator|
          validator.validate_each(self, :timed_one_time_password, timed_one_time_password)
        end
        errors.none?
      end

      def timed_one_time_password_is_correct
        request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(candidate_identity_data)
        if timed_one_time_password_changed?
          clear_attribute_changes(%i[timed_one_time_password])
          @wizard.process_access_token(timed_one_time_password, request)
        end
      rescue GetIntoTeachingApiClient::ApiError
        errors.add(:timed_one_time_password, :wrong_code)
      end
    end
  end
end
