module Content
  class ExpanderComponent < ViewComponent::Base
    attr_reader :header, :title, :text, :link_title, :link_url,
                :background, :expanded, :classes

    include ActiveSupport::Inflector

    def initialize(
      title:, text:, header: "Non-UK citizens:",
      link_title: nil,
      link_url: nil,
      background: "purple",
      expanded: false,
      classes: nil
    )
      super

      @header = header
      @title = title
      @text = text
      @link_title = link_title&.strip&.chomp(".")
      @link_url = link_url
      @background = background
      @expanded = expanded
      @classes = classes

      fail(ArgumentError, "title must be present") if title.blank?
      fail(ArgumentError, "text must be present") if text.blank?
      fail(ArgumentError, "background must be purple") unless %w[purple].any?(background)
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

    def expander_class
      %w[expander-details].tap do |c|
        c << "expander-details__background-#{background}" if background
        c << classes if classes.present?
      end
    end
  end
end
