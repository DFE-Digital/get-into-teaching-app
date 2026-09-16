module Content
  class ExpanderComponent < ViewComponent::Base
    attr_reader :header, :title, :text, :link_title, :link_url,
                :background, :expanded, :classes

    include ActiveSupport::Inflector
    include ContentHelper

    def initialize(
      title:, text: nil, header: "Non-UK citizens:",
      link_title: nil,
      link_url: nil,
      background: "gitpink",
      expanded: false,
      classes: nil
    )
      super

      @header = substitute_values(header)
      @title = substitute_values(title)
      @text = substitute_values(text)
      @link_title = substitute_values(link_title)&.strip&.chomp(".")
      @link_url = link_url
      @background = background
      @expanded = expanded
      @classes = classes

      fail(ArgumentError, "title must be present") if title.blank?
      fail(ArgumentError, "background must be a valid value") unless %w[purple gitpink].any?(background)
    end

    def render_content
      fail(ArgumentError, "text or content must be present") if text.blank? && content.blank?

      if content.present?
        tag.div helpers.safe_html_format substitute_values(content)
      else
        tag.p helpers.safe_html_format text
      end
    end

    def show_link?
      link_url.present? && link_title.present?
    end

    def show_link_id
      parameterize("show #{header} #{title}")
    end

    def hide_link_id
      parameterize("hide #{header} #{title}")
    end

    def details_id
      parameterize("details #{header} #{title}")
    end

    def expander_class
      %w[expander-details].tap do |c|
        c << "expander-details__background-#{background}" if background
        c << classes if classes.present?
      end
    end
  end
end
