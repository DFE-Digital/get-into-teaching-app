module RoutesIntoTeaching
  class Wizard < ::GITWizard::Base
    DEFAULT_ERROR_MESSAGE = "Choose an option from the list"

    self.steps = [
      Steps::UndergraduateDegree,
      Steps::UnqualifiedTeacher,
      Steps::Location,
    ]
  end
end
