module MailingList
  module Steps
    class DegreeStage < ::Wizard::Step
      attribute :degree_status_id
      validates :degree_status_id,
                presence: true,
                inclusion: { in: :degree_status_option_ids, allow_nil: true }

      def skipped?
        @store["describe_yourself_option_id"] != GetIntoTeachingApi::Constants::DESCRIBE_YOURSELF_OPTIONS["Student"]
      end

      def degree_status_options
        @degree_status_options ||= query_degree_status
      end

      def degree_status_option_ids
        degree_status_options.map(&:id)
      end

    private

      def query_degree_status
        GetIntoTeachingApiClient::TypesApi.new.get_qualification_degree_status
      end
    end
  end
end
