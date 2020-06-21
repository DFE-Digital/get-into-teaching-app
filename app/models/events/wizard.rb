module Events
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::PersonalDetails,
      Steps::ContactDetails,
      Steps::FurtherDetails,
    ].freeze
  end
end
