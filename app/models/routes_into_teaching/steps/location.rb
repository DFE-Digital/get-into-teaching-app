module RoutesIntoTeaching::Steps
  class Location < GITWizard::Step
    attribute :location

    validates :location, presence: true

    def seen?
      false
    end
  end
end
