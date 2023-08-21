require "attribute_filter"

module Feedback
  class Wizard < ::GITWizard::Base
    self.steps = [
      Steps::Purpose,
      Steps::Website,
      Steps::WebsiteExperience,
      Steps::WebsiteIssue,
      Steps::Signup,
    ].freeze

    def complete!
      super.tap do |result|
        break unless result

        save_feedback
        @store.purge!
      end
    end

    def save_feedback
      data = export_data.slice("rating", "area", "successful_visit", "unsuccessful_visit_explanation")
      data["area"] = data["area"].split.last
      data["rating"] = data["rating"].to_i
      data.compact!

      feedback = TeacherTrainingAdviser::Feedback.new(data)
      feedback.save!
    end
  end
end
