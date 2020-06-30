module MailingList
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::Name,
    ].freeze
  end
end
