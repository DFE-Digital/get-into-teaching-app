module MailingList
  module Steps
    class DegreeStatus < ::GITWizard::Step
      attribute :degree_status_id, :integer

      validates :degree_status_id,
                presence: true,
                inclusion: { in: :degree_status_option_ids }

      delegate :magic_link_token_used?, to: :@wizard

      def degree_status_options
        @degree_status_options ||= query_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map { |option| option.id.to_i }
      end

    private

      def query_degree_status
        GetIntoTeachingApiClient::PickListItemsApi.new.get_qualification_degree_status
      end
    end
  end
end
