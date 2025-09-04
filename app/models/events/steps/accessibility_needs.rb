module Events
  module Steps
    class AccessibilityNeeds < ::GITWizard::Step
      attribute :accessibility_needs_for_event, :string
      validates :accessibility_needs_for_event, presence: true

      def self.contains_personal_details?
        true
      end

      def skipped?
        other_step(:accessibility_support).support_not_required?
      end
    end
  end
end
