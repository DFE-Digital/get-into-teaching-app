module MailingList
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::Name,
      Steps::Authenticate,
      Steps::DegreeStage,
      Steps::TeacherTraining,
      Steps::Subject,
      Steps::Postcode,
      Steps::Contact,
    ].freeze

    def complete!
      super.tap do |result|
        result && @store.purge!
      end
    end
  end
end
