require "attribute_filter"

module Callbacks
  class Wizard < ::DFEWizard::Base
    include ::Wizard::ApiClientSupport

    self.steps = [
      Steps::PersonalDetails,
      Steps::MatchbackFailed,
      ::Wizard::Steps::Authenticate,
      Steps::Callback,
      Steps::TalkingPoints,
      Steps::PrivacyPolicy,
    ].freeze

    def matchback_attributes
      %i[candidate_id qualification_id].freeze
    end

    def complete!
      super.tap do |result|
        break unless result

        book_callback
        @store.purge!
      end
    end

    def exchange_access_token(timed_one_time_password, request)
      @api ||= GetIntoTeachingApiClient::GetIntoTeachingApi.new
      response = @api.exchange_access_token_for_get_into_teaching_callback(timed_one_time_password, request)
      Rails.logger.info("Callbacks::Wizard#exchange_access_token: #{AttributeFilter.filtered_json(response)}")
      response
    end

  private

    def book_callback
      callback = GetIntoTeachingApiClient::GetIntoTeachingCallback.new(export_camelized_hash)
      api = GetIntoTeachingApiClient::GetIntoTeachingApi.new
      Rails.logger.info("Callbacks::Wizard#book_get_into_teaching_callback: #{AttributeFilter.filtered_json(callback)}")
      api.book_get_into_teaching_callback(callback)
    end
  end
end
