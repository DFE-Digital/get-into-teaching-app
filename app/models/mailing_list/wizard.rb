module MailingList
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::Name,
      Steps::DegreeStage,
      Steps::TeacherTraining,
      Steps::Subject,
    ].freeze
  end
end
