module Events
  module Steps
    class PersonalDetails < ::GITWizard::Steps::Identity
      attribute :is_walk_in, :boolean
      attribute :event_id
      attribute :channel_id, :integer

      validates :event_id, presence: true

      def channel_ids
        query_channels.map { |channel| channel.id.to_i }
      end

      def is_walk_in?
        is_walk_in.present?
      end

      def save
        self.channel_id = nil unless channel_valid?

        super
      end

    private

      def channel_valid?
        channel_id.present? && channel_id.in?(channel_ids)
      end

      def query_channels
        @query_channels ||= GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_event_subscription_channels
      end
    end
  end
end
