require "attribute_filter"

module Callbacks
  class Wizard < ::GITWizard::Base
    self.steps = [
      Steps::Callback,
      Steps::TalkingPoints,
    ].freeze

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
      # byebug
      callback = GetIntoTeachingApiClient::GetIntoTeachingCallback.new(construct_export)
      api = GetIntoTeachingApiClient::GetIntoTeachingApi.new
      Rails.logger.info("Callbacks::Wizard#book_get_into_teaching_callback: #{AttributeFilter.filtered_json(callback)}")
      api.book_get_into_teaching_callback(callback)
    end

    def construct_export
      api = GetIntoTeachingApiClient::GetIntoTeachingApi.new
      sign_up = api.matchback_get_into_teaching_callback(email: @store.fetch("email").values.first)

      attributes = GetIntoTeachingApiClient::GetIntoTeachingCallback.attribute_map.keys
      data = export_data.merge(@store.fetch(%w[first_name last_name email accepted_policy_id]))
      data["candidate_id"] = sign_up.candidate_id

      data.slice(*attributes.map(&:to_s))
    end
  end
end
