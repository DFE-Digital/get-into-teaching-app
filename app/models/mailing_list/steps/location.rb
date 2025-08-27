module MailingList
  module Steps
    class Location < ::GITWizard::Step
      INSIDE_THE_UK = 222_750_000

      attribute :location, :integer
      validates :location,
                presence: { message: "Choose an option from the list" },
                inclusion: { in: :locations_ids }

      include FunnelTitle

      def locations
        @locations ||= PickListItemsApiPresenter.new.get_candidate_location
      end

      def locations_ids
        locations.map { |option| option.id.to_i }
      end

      def skipped?
        other_step(:citizenship).uk_citizen?
      end

      def inside_the_uk?
        location == INSIDE_THE_UK
      end
    end
  end
end
