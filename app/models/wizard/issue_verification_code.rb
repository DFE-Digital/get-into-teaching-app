module Wizard
  module IssueVerificationCode
    extend ActiveSupport::Concern

    def save
      if valid?
        purge_store_retaining_matchback_failures

        Rails.logger.info("#{self.class} requesting access code")

        begin
          request = GetIntoTeachingApiClient::ExistingCandidateRequest.new(request_attributes)
          GetIntoTeachingApiClient::CandidatesApi.new.create_candidate_access_token(request)
          @store["authenticate"] = true
        rescue GetIntoTeachingApiClient::ApiError => e
          @store["matchback_failures"] += 1
          @store["last_matchback_failure_code"] = e.code

          raise if e.code == 429

          Rails.logger.info("#{self.class} potential duplicate (response code #{e.code})") unless e.code == 404

          # Existing candidate not found or CRM is currently unavailable.
          @store["authenticate"] = false
        end
      end

      super
    end

  private

    def purge_store_retaining_matchback_failures
      matchback_failures = @store["matchback_failures"] || 0
      last_matchback_failure_code = @store["last_matchback_failure_code"]

      @store.purge!

      @store["matchback_failures"] = matchback_failures
      @store["last_matchback_failure_code"] = last_matchback_failure_code
    end

    def request_attributes
      attributes.slice("email", "first_name", "last_name").transform_keys { |k| k.camelize(:lower).to_sym }
    end
  end
end
