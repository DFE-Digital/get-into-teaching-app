module CallsToAction
  class RendererComponent < ViewComponent::Base
    CALLS_TO_ACTION = {
      "simple" => CallsToAction::SimpleComponent,
      "chat_online" => CallsToAction::ChatOnlineComponent,
      "story" => CallsToAction::StoryComponent,
      "next_steps" => CallsToAction::NextStepsComponent,
      "multiple_buttons" => CallsToAction::MultipleButtonsComponent,
    }.freeze

    def initialize(params)
      @params = params
    end

    def render?
      @params.present?
    end

    def call
      render(build)
    end

  private

    def build
      if @params.is_a?(Hash)
        advanced_call_to_action_component
      else
        basic_call_to_action_component
      end
    end

    # when the CTA is some static HTML and invoked by name with no args
    #
    # cta: my_call_to_action
    def basic_call_to_action_component
      CALLS_TO_ACTION.fetch(@params).new
    rescue KeyError
      fail(ArgumentError, "call to action not registered: #{@params}")
    end

    # when the CTA is configurable and is defined in the following format:
    #
    # cta:
    #   name: my_call_to_action
    #   arguments:
    #     colour: purple
    #     size: massive
    def advanced_call_to_action_component
      CALLS_TO_ACTION
        .fetch(@params.fetch("name"))
        .new(**@params.fetch("arguments").symbolize_keys)
    rescue KeyError
      fail(ArgumentError, "call to action not properly configured: #{@params}")
    end
  end
end
