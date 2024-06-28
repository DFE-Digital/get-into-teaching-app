module MailingList
  module Steps
    class ReturningTeacher < ::GITWizard::Step
      attribute :qualified_to_teach, :boolean

      validates :qualified_to_teach, inclusion: { in: [true, false], allow_blank: false }
    end
  end
end
