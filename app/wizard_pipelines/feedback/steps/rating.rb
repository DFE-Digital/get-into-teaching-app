module Feedback
  module Steps
    class Rating < ::GITWizard::Step
      RATINGS = [
        OpenStruct.new(id: 0, value: "Very satisfied"),
        OpenStruct.new(id: 1, value: "Somewhat satisfied"),
        OpenStruct.new(id: 2, value: "Neither satisfied nor dissatisfied"),
        OpenStruct.new(id: 3, value: "Somewhat dissatisfied"),
        OpenStruct.new(id: 4, value: "Very dissatisfied"),
      ].freeze

      attribute :rating
      validates :rating, presence: true

      def ratings
        RATINGS
      end

      def can_proceed?
        true
      end
    end
  end
end
