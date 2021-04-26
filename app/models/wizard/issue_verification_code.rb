module Wizard
  module IssueVerificationCode
    extend ActiveSupport::Concern

    def save
      @store.purge!

      if valid?
        Rails.logger.info("#{self.class} requesting access code")

        begin
          request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(request_attributes)
          GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)
          @store["authenticate"] = true
        rescue GetIntoTeachingApiClient::ApiError => e
          raise if e.code == 429

          Rails.logger.info("#{self.class} potential duplicate (response code #{e.code})") unless e.code == 404

          # Existing candidate not found or CRM is currently unavailable.
          @store["authenticate"] = false
        end
      end

      super
    end

  private

    def request_attributes
      attributes.slice("email", "first_name", "last_name").transform_keys { |k| k.camelize(:lower).to_sym }
    end
  end
end
