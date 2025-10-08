module Events
  module Steps
    class AccessibilityNeeds < ::GITWizard::Step
      attribute :accessibility_needs_for_event, :string
      validates :accessibility_needs_for_event, presence: { message: "Enter the accessiblity support you need" }, length: { maximum: 1000 }

      def self.contains_personal_details?
        true
      end

      def skipped?
        other_step(:accessibility_support).no_support_required?
      end
    end
  end
end
