module Content
  class AccordionComponent < ViewComponent::Base
    include ViewComponent::Slotable
    with_slot :step, collection: true, class_name: "Step"

    def render?
      steps.any?
    end

    class Step < ViewComponent::Slot
      attr_accessor :title, :partial, :calls_to_action

      def initialize(title:, calls_to_action: nil)
        @title           = title
        @calls_to_action = calls_to_action
      end
    end
  end
end
