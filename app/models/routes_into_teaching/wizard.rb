module RoutesIntoTeaching
  class Wizard < ::GITWizard::Base
    self.steps = [
      Steps::UndergraduateDegree,
      Steps::UnqualifiedTeacher,
      Steps::Location
    ]

  end
end
