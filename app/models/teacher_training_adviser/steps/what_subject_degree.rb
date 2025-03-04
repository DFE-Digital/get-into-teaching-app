module TeacherTrainingAdviser::Steps
  class WhatSubjectDegree < GITWizard::Step
    attribute :degree_subject, :string
    attr_accessor :degree_subject_raw
    attr_accessor :degree_subject_nojs, :nojs

    validates :degree_subject, presence: true

    def initialize(wizard, store, attributes = {}, *args)
      super
      assign_attributes({ degree_subject_nojs: degree_subject })
    end

    def available_degree_subjects
      @available_degree_subjects ||= DfE::ReferenceData::Degrees::SUBJECTS.all
    end

    def skipped?
      have_a_degree_step = other_step(:have_a_degree)
      have_a_degree_skipped = have_a_degree_step.skipped?
      degree_options = have_a_degree_step.degree_options
      not_studying_or_have_a_degree = [
        HaveADegree::DEGREE_OPTIONS[:studying],
        HaveADegree::DEGREE_OPTIONS[:yes],
      ].none?(degree_options)

      have_a_degree_skipped || not_studying_or_have_a_degree
    end

    def title
      "degree subject"
    end
  end
end
