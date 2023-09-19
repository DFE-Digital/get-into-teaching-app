module Feedback
  module Steps
    class Signup < ::GITWizard::Step
      OPTIONS = [
        OpenStruct.new(id: "1", value: "yes"),
        OpenStruct.new(id: "0", value: "no"),
      ].freeze

      RATINGS = [
        OpenStruct.new(id: 0, value: "Very satisfied"),
        OpenStruct.new(id: 1, value: "Somewhat satisfied"),
        OpenStruct.new(id: 2, value: "Neither satisfied nor dissatisfied"),
        OpenStruct.new(id: 3, value: "Somewhat dissatisfied"),
        OpenStruct.new(id: 4, value: "Very dissatisfied"),
      ].freeze

      attribute :successful_visit
      validates :successful_visit, presence: true, inclusion: { in: OPTIONS.map(&:id) }
      attribute :unsuccessful_visit_explanation
      attribute :rating
      validates :rating, presence: true

      def ratings
        RATINGS
      end

      def options
        OPTIONS
      end

      def can_proceed?
        true
      end

      def skipped?
        website?
      end

      def website?
        @store["topic"] == "Give feedback about the website"
      end
    end
  end
end
