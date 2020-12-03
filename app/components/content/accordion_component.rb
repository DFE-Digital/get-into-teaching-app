module Content
  class AccordionComponent < ViewComponent::Base
    include ViewComponent::Slotable
    with_slot :step, collection: true, class_name: "Step"
    with_slot :content_before_accordion, class_name: "ContentBeforeAccordion"
    with_slot :content_after_accordion, class_name: "ContentAfterAccordion"

    attr_reader :numbered

    def initialize(numbered: false)
      @numbered = numbered
    end

    def render?
      steps.any?
    end

    def numbered?
      numbered
    end

    def number_prefix(number)
      if numbered?
        %(#{number}.)
      end
    end

    class ComposableSlot < ViewComponent::Slot
      attr_reader :call_to_action

      # Calls to action (poppers) are 'registered' here and can
      # be specified via FrontMatter
      CALLS_TO_ACTION = {
        "chat_online" => CallsToAction::ChatOnlineComponent,
        "story" => CallsToAction::StoryComponent,
        "next_steps" => CallsToAction::NextStepsComponent,
      }.freeze

      def build(call_to_action)
        @call_to_action = if call_to_action.is_a?(Hash)
                            advanced_call_to_action_component(call_to_action)
                          else
                            basic_call_to_action_component(call_to_action)
                          end
      end

    private

      # when the CTA is some static HTML and invoked by name with no args
      #
      # cta: my_call_to_action
      def basic_call_to_action_component(call_to_action)
        return if call_to_action.blank?

        CALLS_TO_ACTION.fetch(call_to_action).new
      rescue KeyError
        fail(ArgumentError, "call to action not registered: #{call_to_action}")
      end

      # when the CTA is configurable and is defined in the following format:
      #
      # cta:
      #   name: my_call_to_action
      #   arguments:
      #     colour: purple
      #     size: massive
      def advanced_call_to_action_component(call_to_action)
        return if call_to_action.blank?

        CALLS_TO_ACTION
          .fetch(call_to_action.fetch("name"))
          .new(**call_to_action.fetch("arguments").symbolize_keys)
      rescue KeyError
        fail(ArgumentError, "call to action properly configured: #{call_to_action}")
      end
    end

    class Step < ComposableSlot
      attr_accessor :title, :partial

      def initialize(title:, call_to_action: nil)
        @title = title
        @call_to_action = build(call_to_action)
      end
    end

    class ContentAroundSlot < ComposableSlot
      attr_accessor :partial

      def initialize(call_to_action: nil, partial: nil)
        @call_to_action = build(call_to_action)
        @partial = partial
      end
    end

    class ContentBeforeAccordion < ContentAroundSlot; end
    class ContentAfterAccordion < ContentAroundSlot; end
  end
end
