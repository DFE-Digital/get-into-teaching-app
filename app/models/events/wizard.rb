module Events
  class Wizard < ::Wizard::Base
    self.steps = [
      Steps::PersonalDetails,
      Steps::Authenticate,
      Steps::ContactDetails,
      Steps::FurtherDetails,
    ].freeze

    def complete!
      super.tap do |result|
        result && @store.purge!
      end
    end
  end
end
