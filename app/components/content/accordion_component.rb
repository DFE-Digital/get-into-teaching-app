module Content
  class AccordionComponent < ViewComponent::Base
    include ViewComponent::Slotable
    with_slot :step, collection: true, class_name: "Step"

    def render?
      steps.any?
    end

    class Step < ViewComponent::Slot
      attr_accessor :title, :partial, :call_to_action

      # Calls to action (poppers) are 'registered' here and can
      # be specified via FrontMatter
      CALLS_TO_ACTION = {
        "chat_online" => Content::Accordion::ChatOnlineComponent,
      }.freeze

      def initialize(title:, call_to_action: nil)
        @title          = title
        @call_to_action = call_to_action_component(call_to_action)&.new
      end

    private

      def call_to_action_component(call_to_action)
        return if call_to_action.blank?

        CALLS_TO_ACTION.fetch(call_to_action)
      rescue KeyError
        fail(ArgumentError, "call to action not registered: #{call_to_action}")
      end
    end
  end
end
