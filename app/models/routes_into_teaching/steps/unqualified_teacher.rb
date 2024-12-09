module RoutesIntoTeaching::Steps
  class UnqualifiedTeacher < GITWizard::Step
    attribute :has_worked_as_unqualified_teacher

    validates :has_worked_as_unqualified_teacher, presence: true

    def seen?
      false
    end
  end
end
