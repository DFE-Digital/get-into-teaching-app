module TeacherTrainingAdviser::Steps
  class WhatSubjectDegree < GITWizard::Step
    attribute :degree_subject, :string
    attr_accessor :degree_subject_raw
    attr_accessor :degree_subject_nojs, :nojs

    validates :degree_subject, presence: true

    include FunnelTitle

    def initialize(wizard, store, attributes = {}, *args)
      super
      assign_attributes({ degree_subject_nojs: degree_subject })
    end

    def available_degree_subjects
      @available_degree_subjects ||= DfE::ReferenceData::Degrees::SUBJECTS.all
    end

    def skipped?
      degree_status_step = other_step(:degree_status)
      not_studying_or_have_a_degree = !(degree_status_step.has_degree? || degree_status_step.degree_in_progress?)

      degree_status_step.skipped? || not_studying_or_have_a_degree
    end
  end
end
