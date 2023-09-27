module Feedback
  module Steps
    class Signup < ::GITWizard::Step
      OPTIONS = [
        OpenStruct.new(id: "1", value: "yes"),
        OpenStruct.new(id: "0", value: "no"),
      ].freeze

      attribute :successful_visit
      validates :successful_visit, presence: true, inclusion: { in: OPTIONS.map(&:id) }

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
