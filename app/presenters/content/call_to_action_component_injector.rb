module Content
  class CallToActionComponentInjector
    CALLS_TO_ACTION = {
      "attachment" => CallsToAction::AttachmentComponent,
      "simple" => CallsToAction::SimpleComponent,
      "chat" => ChatComponent,
      "chat_online" => CallsToAction::ChatOnlineComponent,
      "story" => CallsToAction::StoryComponent,
      "next_steps" => CallsToAction::NextStepsComponent,
      "multiple_buttons" => CallsToAction::MultipleButtonsComponent,
      "ect" => CallsToAction::EctComponent,
      "feature_table" => Content::FeatureTableComponent,
    }.freeze

    def initialize(params)
      @params = params
    end

    def component
      return unless @params

      if @params.is_a?(Hash)
        advanced_call_to_action_component
      else
        basic_call_to_action_component
      end
    end

  private

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
      args, kwargs = *advanced_arguments

      CALLS_TO_ACTION
        .fetch(@params.fetch("name"))
        .new(*args, **kwargs)
    rescue KeyError
      fail(ArgumentError, "call to action not properly configured: #{@params}")
    end

    # component params can be passed as either an array or hash but not
    # a combination
    def advanced_arguments
      args = @params.fetch("arguments")

      case args
      when Array
        [args, {}]
      when Hash
        [[], args.symbolize_keys]
      end
    end
  end
end
