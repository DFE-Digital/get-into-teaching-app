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
    end
  end
end
