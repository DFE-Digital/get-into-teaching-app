module Events
  module Steps
    class PersonalDetails < ::GITWizard::Steps::Identity
      attribute :is_walk_in, :boolean
      attribute :event_id
      attribute :channel_id, :integer

      validates :event_id, presence: true

      def is_walk_in?
        is_walk_in.present?
      end
    end
  end
end
