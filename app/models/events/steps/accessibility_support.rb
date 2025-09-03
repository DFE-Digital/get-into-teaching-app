module Events
  module Steps
    class AccessibilitySupport < ::GITWizard::Step

      OPTIONS = {
        "Yes" => YES = 1,
        "No" => NO = 0,
      }.freeze

      attribute :support_required, :integer

      validates :support_required,
                presence: { message: "Choose an option from the list" },
                inclusion: { in: OPTIONS.values }

      def support_required?
        support_required == YES
      end
    end
  end
end
