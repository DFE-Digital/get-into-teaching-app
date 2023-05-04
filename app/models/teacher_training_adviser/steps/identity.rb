module TeacherTrainingAdviser::Steps
  class Identity < GITWizard::Steps::Identity
    attribute :channel_id, :integer
    attribute :sub_channel_id

    def export
      super.without("sub_channel_id")
    end

    def reviewable_answers
      super.without(%w[channel_id sub_channel_id])
    end

    def channel_ids
      query_channels.map { |channel| channel.id.to_i }
    end

    def save
      self.channel_id = nil if channel_invalid?

      super
    end

    def title
      nil
    end

  private

    def channel_invalid?
      channel_id.present? && !channel_id.in?(channel_ids)
    end

    def query_channels
      @query_channels ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_teacher_training_adviser_subscription_channels
    end
  end
end
