module MailingList
  module Steps
    class TeacherTraining < ::Wizard::Step
      STATUSES = [
        "It's just an idea",
        "I'm not sure and finding out more",
        "I'm fairly sure and exploring my options",
        "I'm very sure and think I'll apply",
      ].freeze

      attribute :teacher_training
      validates :teacher_training,
                presence: true,
                inclusion: { in: STATUSES, allow_nil: true }

      class << self
        def statuses
          STATUSES
        end
      end
    end
  end
end
