module Callbacks
  module Steps
    class PersonalDetails < ::GITWizard::Steps::Identity
      attribute :creation_channel_source_id, :integer
      attribute :creation_channel_service_id, :integer
      attribute :creation_channel_activity_id, :integer

      DEFAULT_CREATION_CHANNEL_SOURCE_ID = 222_750_003   # GIT Website
      DEFAULT_CREATION_CHANNEL_SERVICE_ID = 222_750_005  # Explore Teaching Adviser Service TODO: check this value
      DEFAULT_CREATION_CHANNEL_ACTIVITY_ID = nil # default to blank

      def save
        self.creation_channel_source_id = DEFAULT_CREATION_CHANNEL_SOURCE_ID unless creation_channel_source_id.in?(creation_channel_source_ids)
        self.creation_channel_service_id = DEFAULT_CREATION_CHANNEL_SERVICE_ID unless creation_channel_service_id.in?(creation_channel_service_ids)
        self.creation_channel_activity_id = DEFAULT_CREATION_CHANNEL_ACTIVITY_ID unless creation_channel_activity_id.in?(creation_channel_activity_ids)
        super
      end

    private

      def creation_channel_source_ids
        @creation_channel_source_ids ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_contact_creation_channel_sources.map { |obj| obj.id.to_i }
      end

      def creation_channel_service_ids
        @creation_channel_service_ids ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_contact_creation_channel_services.map { |obj| obj.id.to_i }
      end

      def creation_channel_activity_ids
        @creation_channel_activity_ids ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_contact_creation_channel_activities.map { |obj| obj.id.to_i }
      end
    end
  end
end
