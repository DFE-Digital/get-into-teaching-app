module RoutesIntoTeaching::Steps
  class UnqualifiedTeacher < GITWizard::Step
    attribute :unqualified_teacher

    validates :unqualified_teacher, presence: { message: RoutesIntoTeaching::Wizard::DEFAULT_ERROR_MESSAGE }

    def seen?
      false
    end

    def title
      "unqualified teacher"
    end
  end
end
