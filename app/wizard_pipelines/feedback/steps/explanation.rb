# frozen_string_literal: true

module Feedback
  module Steps
    class Explanation < GITWizard::Step
      attribute :explanation
      validates :explanation, presence: true

      def can_proceed?
        true
      end
    end
  end
end
