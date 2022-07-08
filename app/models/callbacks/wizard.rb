require "attribute_filter"

module Callbacks
  class Wizard < ::GITWizard::Base
    self.steps = [
      Steps::PersonalDetails,
      Steps::MatchbackFailed,
      ::GITWizard::Steps::Authenticate,
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
      callback = GetIntoTeachingApiClient::GetIntoTeachingCallback.new(construct_export)
      api = GetIntoTeachingApiClient::GetIntoTeachingApi.new
      Rails.logger.info("Callbacks::Wizard#book_get_into_teaching_callback: #{AttributeFilter.filtered_json(callback)}")
      api.book_get_into_teaching_callback(callback)
    end

    def construct_export
      attributes = GetIntoTeachingApiClient::GetIntoTeachingCallback.attribute_map.keys
      export_data.slice(*attributes.map(&:to_s))
    end
  end
end
