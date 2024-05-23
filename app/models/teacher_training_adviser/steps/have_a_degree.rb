module TeacherTrainingAdviser::Steps
  class HaveADegree < GITWizard::Step
    attribute :degree_options, :string
    attribute :degree_status_id, :integer
    attribute :degree_type_id, :integer

    DEGREE_OPTIONS = {
      yes: "yes",
      equivalent: "equivalent",
      studying: "studying",
      no: "no",
    }.freeze

    DEGREE_STATUS_OPTIONS = {
      has_degree: 222_750_000,
      no_degree: 222_750_004,
      studying: -1, # degree_status_id is set on the subsequent step.
    }.freeze

    DEGREE_TYPE_OPTIONS = {
      has_degree: 222_750_000,
      has_degree_equivalent: 222_750_005,
    }.freeze

    validates :degree_options, inclusion: { in: DEGREE_OPTIONS.values }

    def degree_options=(value)
      super
      set_degree_status
      set_degree_type
    end

    def studying?
      degree_options == HaveADegree::DEGREE_OPTIONS[:studying]
    end

    def reviewable_answers
      {
        "degree_options" => degree_options ? I18n.t("have_a_degree.degree_options.#{degree_options}", **Value.data) : nil,
      }
    end

    def skipped?
      other_step(:returning_teacher).returning_to_teaching
    end

    def set_degree_status
      self.degree_status_id = case degree_options
                              when DEGREE_OPTIONS[:no]
                                DEGREE_STATUS_OPTIONS[:no_degree]
                              when DEGREE_OPTIONS[:studying]
                                DEGREE_STATUS_OPTIONS[:studying]
                              else
                                DEGREE_STATUS_OPTIONS[:has_degree]
                              end
    end

    def set_degree_type
      self.degree_type_id = case degree_options
                            when DEGREE_OPTIONS[:equivalent]
                              DEGREE_TYPE_OPTIONS[:has_degree_equivalent]
                            else
                              DEGREE_TYPE_OPTIONS[:has_degree]
                            end
    end
  end
end
