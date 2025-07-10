module MailingList
  module Steps
    class LifeStage < ::GITWizard::Step
      attribute :situation, :integer
      validates :situation,
                presence: true,
                inclusion: { in: :situation_ids }

      include FunnelTitle

      def situations
        @situations ||= ::PickListItemsApiPresenter.new.get_candidate_situations_for_mailing_list
      end

      def situation_ids
        situations.map { |option| option.id.to_i }
      end
    end
  end
end
