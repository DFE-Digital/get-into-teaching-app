module TeacherTrainingAdviser::Steps
  class StageInterestedTeaching < GITWizard::Step
    extend ApiOptions

    before_validation :primary_subject_preferred, if: :interested_in_primary?

    attribute :preferred_education_phase_id, :integer
    attribute :preferred_teaching_subject_id, :string

    validates :preferred_education_phase_id, pick_list_items: { method: :get_candidate_preferred_education_phases }
    validates :preferred_teaching_subject_id, inclusion: { in: [Crm::TeachingSubject::PRIMARY] }, if: :interested_in_primary?

    OPTIONS = { primary: 222_750_000, secondary: 222_750_001 }.freeze

    def reviewable_answers
      super.tap do |answers|
        answers["preferred_education_phase_id"] = OPTIONS.key(preferred_education_phase_id).to_s.capitalize
        answers["preferred_teaching_subject_id"] = Crm::TeachingSubject.lookup_by_uuid(preferred_teaching_subject_id)
      end
    end

    def interested_in_primary?
      preferred_education_phase_id == OPTIONS[:primary]
    end

    def returning_teacher?
      other_step(:returning_teacher).returning_to_teaching
    end

    private

    def primary_subject_preferred
      assign_attributes(preferred_teaching_subject_id: Crm::TeachingSubject::PRIMARY)
    end
  end
end
