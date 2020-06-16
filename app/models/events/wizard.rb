module Events
  class Wizard < ::Wizard::Base
    self.steps = [Steps::PersonalDetails, Steps::ContactDetails].freeze
  end
end
