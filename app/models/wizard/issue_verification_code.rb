module Wizard
  module IssueVerificationCode
    extend ActiveSupport::Concern

    def save
      @store.purge! if previously_authenticated?

      if valid?
        begin
          request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(request_attributes)
          GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)
          @store["authenticate"] = true
        rescue GetIntoTeachingApiClient::ApiError => e
          raise if e.code == 429

          # Existing candidate not found or CRM is currently unavailable.
          @store["authenticate"] = false
        end
      end

      super
    end

  private

    def previously_authenticated?
      @store["authenticated"]
    end

    def request_attributes
      attributes.slice("email", "first_name", "last_name").transform_keys { |k| k.camelize(:lower).to_sym }
    end
  end
end
