module MailingList
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::Name,
      Steps::DegreeStage,
    ].freeze
  end
end
