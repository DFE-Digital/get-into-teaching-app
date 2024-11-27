module Content
  class LinkAsButtonComponent < ViewComponent::Base
    attr_reader :link_text, :href, :tabindex, :data, :id, :classes

    include ContentHelper

    def initialize(link_text:, href:, tabindex: nil, data: {}, id: nil, css_class: [], **kwargs)
      super

      raise ArgumentError, "Unhandled attributes: #{kwargs.keys.join(', ')}" if kwargs.any?

      @link_text = substitute_values(link_text)
      @href = href
      @tabindex = tabindex
      @data = data
      @id = id
      @classes = css_class.is_a?(Array) ? css_class : [css_class]
    end

    def combined_options
      {
        class: ["button", *classes].compact.join(" "),
        tabindex: tabindex,
        data: data,
        id: id,
        role: "button",
      }.compact
    end
  end
end
