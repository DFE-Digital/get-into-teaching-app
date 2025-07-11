module MailingList
  module Steps
    class Subject < ::GITWizard::Step
      attribute :preferred_teaching_subject_id
      validates :preferred_teaching_subject_id,
                presence: true,
                inclusion: { in: :teaching_subject_ids }

      include FunnelTitle

      def teaching_subjects
        @teaching_subjects ||= query_teaching_subjects
      end

      def teaching_subject_ids
        teaching_subjects.map(&:id)
      end

    private

      def query_teaching_subjects
        Crm::TeachingSubject.all
      end
    end
  end
end
