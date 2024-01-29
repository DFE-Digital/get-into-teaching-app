module Content
  class QuoteComponent < ViewComponent::Base
    attr_reader :text, :name, :job_title, :cta, :image, :inline, :background, :large

    def initialize(
      text:,
      name: nil,
      job_title: nil,
      image: nil,
      inline: nil,
      background: "yellow",
      large: false
    )
      super

      @text = text
      @name = name
      @job_title = job_title
      @image = image
      @inline = inline
      @background = background
      @large = large

      fail(ArgumentError, "text must be present") if text.blank?
      fail(ArgumentError, "background must be yellow or grey") unless %w[yellow grey white].any?(background)
      fail(ArgumentError, "inline must be right or left or full") unless inline.nil? || %w[right left full].any?(inline)
    end

    def show_footer?
      footer_attrs = [name, job_title, image]
      footer_attrs.any?(&:present?)
    end

    def text_last_word
      text.split.last
    end

    def text_sans_last_word
      text.split[0...-1].join(" ")
    end

    def quote_class
      %w[quote].tap do |c|
        c << "quote--inline-#{inline}" if inline
        c << "quote--background-#{background}" if background
        c << "quote--large" if large
      end
    end
  end
end
