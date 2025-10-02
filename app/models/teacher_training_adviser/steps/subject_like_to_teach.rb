module TeacherTrainingAdviser::Steps
  class SubjectLikeToTeach < GITWizard::Step
    attribute :preferred_teaching_subject_id, :string

    validates :preferred_teaching_subject_id, lookup_items: { method: :get_teaching_subjects }

    include FunnelTitle

    def self.options
      Crm::TeachingSubject.all_without_primary
    end

    def skipped?
      degree_country_step = other_step(:degree_country)

      !other_step(:returning_teacher).returning_to_teaching ||
        other_step(:stage_interested_teaching).interested_in_primary? ||
        degree_country_step.another_country?
    end

    def reviewable_answers
      super.tap do |answers|
        answers["preferred_teaching_subject_id"] = Crm::TeachingSubject.lookup_by_uuid(preferred_teaching_subject_id)
      end
    end
  end
end
