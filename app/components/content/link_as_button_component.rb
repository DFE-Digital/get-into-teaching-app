module Content
  class LinkAsButtonComponent < ViewComponent::Base
    attr_reader :link_text, :url, :options

    include ContentHelper

    def initialize(link_text:, url:, options: {})
      super

      @link_text = substitute_values(link_text)
      @url = url
      @options = options
    end

    def combined_options
      allowed_keys = %i[class tabindex data id]
      filtered_options = options.slice(*allowed_keys)

      disallowed_keys = options.keys - allowed_keys
      if disallowed_keys.any?
        raise ArgumentError, "Unexpected attributes: #{disallowed_keys.join(', ')}"
      end

      filtered_options.merge(
        class: ["button", options[:class]].compact.join(" "),
        role: "button",
      )
    end
  end
end
