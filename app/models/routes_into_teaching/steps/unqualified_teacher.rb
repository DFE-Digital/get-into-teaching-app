module RoutesIntoTeaching::Steps
  class UnqualifiedTeacher < GITWizard::Step
    attribute :unqualified_teacher

    validates :unqualified_teacher, presence: true

    def seen?
      false
    end
  end
end
