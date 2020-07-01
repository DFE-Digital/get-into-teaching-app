module MailingList
  module Steps
    class DegreeStage < ::Wizard::Step
      STAGES = [
        "Graduate or postgraduate",
        "First year at university",
        "Second year at university",
        "Final year at university",
      ].freeze

      attribute :degree_stage
      validates :degree_stage,
                presence: true,
                inclusion: { in: STAGES, allow_nil: true }

      class << self
        def stages
          STAGES
        end
      end
    end
  end
end
