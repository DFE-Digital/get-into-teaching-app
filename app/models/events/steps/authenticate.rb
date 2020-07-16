module Events
  module Steps
    class Authenticate < ::Wizard::Step
      attribute :timed_one_time_password

      validates :timed_one_time_password, presence: true, length: { is: 6 }, format: { with: /\A[0-9]*\z/, message: "can only contain numbers" }
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

    private

      def timed_one_time_password_valid?
        self.class.validators_on(:timed_one_time_password).each do |validator|
          validator.validate_each(self, :timed_one_time_password, timed_one_time_password)
        end
        errors.none?
      end

      def timed_one_time_password_is_correct
        request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(
          @store.fetch("email", "first_name", "last_name").transform_keys { |k| k.camelize(:lower).to_sym },
        )
        @api ||= GetIntoTeachingApiClient::TeachingEventsApi.new
        @totp_response ||= @api.get_pre_filled_teaching_event_add_attendee(timed_one_time_password, request)
      rescue GetIntoTeachingApiClient::ApiError
        errors.add(:timed_one_time_password, "is not correct")
      end

      def prepopulate_store
        attribute_map = GetIntoTeachingApiClient::TeachingEventAddAttendee.attribute_map
        hash = attribute_map.map { |k, _v| { k => @totp_response.send(k) } }.reduce(:merge)
        @store.persist(hash.except(:email, :first_name, :last_name))
      end
    end
  end
end
