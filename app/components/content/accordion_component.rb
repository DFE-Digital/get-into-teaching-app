module Content
  class AccordionComponent < ViewComponent::Base
    include ViewComponent::Slotable
    renders_many :steps, "Step"
    renders_one :content_before_accordion, "ContentBeforeAccordion"
    renders_one :content_after_accordion, "ContentAfterAccordion"

    attr_reader :numbered

    def initialize(numbered: false, active_step: nil)
      @numbered    = numbered
      @active_step = active_step
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

    def data_attributes
      { controller: "accordion", accordion_active_step_value: @active_step }.compact
    end

    class ComposableSlot < ViewComponent::Base
      attr_reader :call_to_action
    end

    class Step < ComposableSlot
      attr_accessor :title, :partial

      def initialize(title:, call_to_action: nil)
        @title = title
        @call_to_action = Content::CallToActionComponentInjector.new(call_to_action).component
      end

      def call
        helpers.tag.div(content, class: "step-content__description")
      end
    end

    class ContentAroundSlot < ComposableSlot
      attr_accessor :partial

      def initialize(call_to_action: nil, partial: nil)
        @call_to_action = Content::CallToActionComponentInjector.new(call_to_action).component
        @partial = partial
      end
    end

    class ContentBeforeAccordion < ContentAroundSlot; end
    class ContentAfterAccordion < ContentAroundSlot; end
  end
end
