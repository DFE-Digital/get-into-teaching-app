module Feedback
  module Steps
    class WebsiteIssue < ::GITWizard::Step
      attribute :unsuccessful_visit_explanation
      attribute :rating
      validates :rating, presence: true

      OPTIONS = [
        OpenStruct.new(id: 0, value: "Very satisfied"),
        OpenStruct.new(id: 1, value: "Somewhat satisfied"),
        OpenStruct.new(id: 2, value: "Neither satisfied nor dissatisfied"),
        OpenStruct.new(id: 3, value: "Somewhat dissatisfied"),
        OpenStruct.new(id: 4, value: "Very dissatisfied"),
      ].freeze

      def options
        OPTIONS
      end

      def can_proceed?
        true
      end

      def skipped?
        website_step = other_step(:website)
        improving_feedback = @store["value"] == "Give general feedback about the website"
        website_step.skipped? || !!improving_feedback
      end
    end
  end
end
