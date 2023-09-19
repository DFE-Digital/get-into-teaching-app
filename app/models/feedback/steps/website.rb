module Feedback
  module Steps
    class Website < ::GITWizard::Step
      OPTIONS = [
        OpenStruct.new(id: "Give general feedback about the website", value: "Give general feedback about the website"),
        OpenStruct.new(id: "Tell us something is not working or needs improving", value: "Tell us something is not working or needs improving"),
      ].freeze

      attribute :value
      validates :value, presence: true, inclusion: { in: OPTIONS.map(&:id) }

      def options
        OPTIONS
      end

      def can_proceed?
        true
      end

      def skipped?
        !website?
      end

      def website?
        @store["topic"] == "Give feedback about the website"
      end
    end
  end
end
