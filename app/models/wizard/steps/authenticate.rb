module Wizard
  module Steps
    class Authenticate < ::Wizard::Step
      attribute :timed_one_time_password

      validates :timed_one_time_password, presence: true, length: { is: 6, message: :invalid },
                                          format: { with: /\A[0-9]*\z/, message: :invalid }
      validate :timed_one_time_password_is_correct, if: :timed_one_time_password_valid?

      before_validation if: :timed_one_time_password do
        self.timed_one_time_password = timed_one_time_password.to_s.strip
      end

      def skipped?
        @store["authenticate"] == false
      end

      def save
        prepopulate_store if valid?

        super
      end

      def timed_one_time_password=(value)
        @totp_response = nil if value != timed_one_time_password
        super(value)
      end

    protected

      def perform_existing_candidate_request(_request)
        raise NotImplementedError, "subclass must define #perform_existing_candidate_request"
      end

    private

      def timed_one_time_password_valid?
        self.class.validators_on(:timed_one_time_password).each do |validator|
          validator.validate_each(self, :timed_one_time_password, timed_one_time_password)
        end
        errors.none?
      end

      def timed_one_time_password_is_correct
        request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(@store.to_camelized_hash)
        @totp_response ||= perform_existing_candidate_request(request)
      rescue GetIntoTeachingApiClient::ApiError
        errors.add(:timed_one_time_password, :wrong_code)
      end

      def prepopulate_store
        hash = @totp_response.to_hash.transform_keys { |k| k.to_s.underscore }
        @store.persist(hash.except(*@store.keys))
      end
    end
  end
end
