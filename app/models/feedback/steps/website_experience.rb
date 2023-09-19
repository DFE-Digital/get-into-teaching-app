module Feedback
  module Steps
    class WebsiteExperience < ::GITWizard::Step
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
        general_feedback = @store["value"] == "Tell us something is not working or needs improving"
        website_step.skipped? || !!general_feedback
      end
    end
  end
end
