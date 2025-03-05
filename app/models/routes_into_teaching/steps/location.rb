module RoutesIntoTeaching::Steps
  class Location < GITWizard::Step
    attribute :location

    validates :location, presence: { message: RoutesIntoTeaching::Wizard::DEFAULT_ERROR_MESSAGE }

    def seen?
      false
    end

    def title
      "location"
    end
  end
end
