module TeacherTrainingAdviser::Steps
  class ReturningTeacher < GITWizard::Step
    OPTIONS = { returning_to_teaching: 222_750_001, interested_in_teaching: 222_750_000 }.freeze

    attribute :type_id, :integer
    attribute :creation_channel_service_id, :integer

    validates :type_id, pick_list_items: { method: :get_candidate_types }

    RTTA_DEFAULT_CREATION_CHANNEL_SERVICE_ID = 222_750_009 # Return to Teacher Training Adviser Service
    TTA_DEFAULT_CREATION_CHANNEL_SERVICE_ID = 222_750_010 # Teacher Training Adviser Service
    ETA_DEFAULT_CREATION_CHANNEL_SERVICE_ID = 222_750_005 # Explore Teaching Adviser Service (not in final year of degree)

    def returning_to_teaching
      type_id == OPTIONS[:returning_to_teaching]
    end

    def reviewable_answers
      {
        "returning_to_teaching" => returning_to_teaching ? "Yes" : "No",
      }
    end

    def save
      if creation_channel_source_id.nil? && channel_id.present?
        # if the new creation_channel_source_id is missing and a valid legacy channel_id is provided, use the legacy channel only
        self.creation_channel_service_id = nil
      elsif !creation_channel_service_id.in?(creation_channel_service_ids)
        # otherwise set the new creation_channel fields and set the legacy channel_id to be nil

        self.creation_channel_service_id = returning_to_teaching ? RTTA_DEFAULT_CREATION_CHANNEL_SERVICE_ID : TTA_DEFAULT_CREATION_CHANNEL_SERVICE_ID
      end
      super
    end

    def creation_channel_service_ids
      @creation_channel_service_ids ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_contact_creation_channel_services.map { |obj| obj.id.to_i }
    end

  private

    def channel_id
      other_step(:identity).channel_id
    end

    def creation_channel_source_id
      other_step(:identity).creation_channel_source_id
    end
  end
end
