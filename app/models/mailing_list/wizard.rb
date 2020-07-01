module MailingList
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::Name,
      Steps::DegreeStage,
      Steps::TeacherTraining,
    ].freeze
  end
end
