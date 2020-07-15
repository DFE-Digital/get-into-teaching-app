module Events
  module Steps
    class PersonalDetails < ::Wizard::Step
      attribute :email
      attribute :first_name
      attribute :last_name
      attribute :authenticate

      validates :email, presence: true, email_format: true
      validates :first_name, presence: true
      validates :last_name, presence: true

      before_validation if: :email do
        self.email = email.to_s.strip
      end

      before_validation if: :first_name do
        self.first_name = first_name.to_s.strip
      end

      before_validation if: :last_name do
        self.last_name = last_name.to_s.strip
      end

      def save
        if valid?
          begin
            request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(request_attributes)
            GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)
            self.authenticate = true
          rescue GetIntoTeachingApiClient::ApiError
            # Existing candidate not found or CRM is currently unavailable.
            self.authenticate = false
          end
        end

        super
      end

    private

      def request_attributes
        attributes.slice("email", "first_name", "last_name").transform_keys do |k|
          GetIntoTeachingApiClient::ExistingCandidateRequest.attribute_map[k.to_sym]
        end
      end
    end
  end
end
