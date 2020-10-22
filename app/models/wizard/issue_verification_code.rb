module Wizard
  module IssueVerificationCode
    extend ActiveSupport::Concern

    TOO_MANY_REQUESTS = 429

    included { validate :too_many_requests }

    def save
      @store.purge! if previously_authenticated?
      @too_many_requests = false

      if valid?
        begin
          request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(request_attributes)
          GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request, x_client_ip: @wizard.client_ip)
          @store["authenticate"] = true
        rescue GetIntoTeachingApiClient::ApiError => e
          if e.code == TOO_MANY_REQUESTS
            @too_many_requests = true
          else
            # Existing candidate not found or CRM is currently unavailable.
            @store["authenticate"] = false
          end
        end
      end

      super
    end

  private

    def too_many_requests
      return unless @too_many_requests

      errors.add(:base, :too_many_requests)
    end

    def previously_authenticated?
      @store["authenticate"]
    end

    def request_attributes
      attributes.slice("email", "first_name", "last_name").transform_keys { |k| k.camelize(:lower).to_sym }
    end
  end
end
