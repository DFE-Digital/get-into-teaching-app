module TeacherTrainingAdviser::Steps
  class Identity < GITWizard::Steps::Identity
    attribute :channel_id, :integer
    attribute :creation_channel_source_id, :integer
    attribute :creation_channel_service_id, :integer
    attribute :creation_channel_activity_id, :integer
    attribute :sub_channel_id

    DEFAULT_CHANNEL_ID = nil
    DEFAULT_CREATION_CHANNEL_SOURCE_ID = 222750003   # GIT Website
    DEFAULT_CREATION_CHANNEL_SERVICE_ID = 222750010  # Teacher Training Adviser Service
    DEFAULT_CREATION_CHANNEL_ACTIVITY_ID = nil       # default to blank

    def export
      super.without("sub_channel_id")
    end

    def reviewable_answers
      super.without(%w[channel_id sub_channel_id creation_channel_source_id creation_channel_service_id creation_channel_activity_id])
    end

    def save
      if channel_id.present? && creation_channel_source_id.nil?
        # if a legacy channel_id is provided and the new creation_channel_source_id is missing, use the legacy channel
        self.channel_id = DEFAULT_CHANNEL_ID unless channel_id.in?(legacy_channel_ids)
        self.creation_channel_source_id = nil
        self.creation_channel_service_id = nil
        self.creation_channel_activity_id = nil
      else
        # otherwise set the new creation_channel fields and set the legacy channel_id to be nil
        self.channel_id = DEFAULT_CHANNEL_ID # channel_id will always be nil as we use the creation channel structure going forwards
        self.creation_channel_source_id = DEFAULT_CREATION_CHANNEL_SOURCE_ID unless creation_channel_source_id.in?(creation_channel_source_ids)
        self.creation_channel_service_id = DEFAULT_CREATION_CHANNEL_SERVICE_ID unless creation_channel_service_id.in?(creation_channel_service_ids)
        self.creation_channel_activity_id = DEFAULT_CREATION_CHANNEL_ACTIVITY_ID unless creation_channel_activity_id.in?(creation_channel_activity_ids)
      end
      super
    end

    def title
      nil
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

    def legacy_channel_ids
      @legacy_channel_ids ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_teacher_training_adviser_subscription_channels.map { |obj| obj.id.to_i }
    end
  end
end
