module Events
  class Wizard < ::Wizard::Base
    self.steps = [Steps::PersonalDetails].freeze
  end
end
