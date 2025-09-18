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

      def no_support_required?
        support_required == NO
      end
    end
  end
end
