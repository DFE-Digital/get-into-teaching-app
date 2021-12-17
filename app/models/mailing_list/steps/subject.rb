module MailingList
  module Steps
    class Subject < ::DFEWizard::Step
      attribute :preferred_teaching_subject_id
      validates :preferred_teaching_subject_id,
                presence: true,
                inclusion: { in: :teaching_subject_ids }

      def teaching_subjects
        @teaching_subjects ||= query_teaching_subjects
      end

      def teaching_subject_ids
        teaching_subjects.map(&:id)
      end

    private

      def query_teaching_subjects
        GetIntoTeachingApiClient::LookupItemsApi.new.get_teaching_subjects.reject do |type|
          TeachingSubject.ignore?(type.id)
        end
      end
    end
  end
end
