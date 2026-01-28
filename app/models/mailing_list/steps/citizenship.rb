module MailingList
  module Steps
    class Citizenship < ::GITWizard::Step
      UK_CITIZEN = 222_750_000
      NON_UK_CITIZEN = 222_750_001

      attribute :citizenship, :integer
      validates :citizenship,
                presence: { message: "Choose an option from the list" },
                inclusion: { in: :citizenship_ids }

      include FunnelTitle

      def citizenships
        @citizenships ||= PickListItemsApiPresenter.new.get_candidate_citizenship
      end

      def citizenship_ids
        citizenships.map { |option| option.id.to_i }
      end

      def uk_citizen?
        citizenship == UK_CITIZEN
      end
    end
  end
end
