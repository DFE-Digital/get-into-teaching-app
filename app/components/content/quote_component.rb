module Content
  class QuoteComponent < ViewComponent::Base
    attr_reader :text, :name, :job_title, :cta, :image, :inline, :background, :large, :classes

    include ContentHelper

    def initialize(
      text:,
      name: nil,
      job_title: nil,
      image: nil,
      inline: nil,
      background: "white",
      large: false,
      classes: nil
    )
      super

      @text = substitute_values(text)
      @name = substitute_values(name)
      @job_title = substitute_values(job_title)
      @image = image
      @inline = inline
      @background = background
      @large = large
      @classes = classes

      fail(ArgumentError, "text must be present") if text.blank?
      fail(ArgumentError, "background must be grey or white") unless %w[grey white].any?(background)
      fail(ArgumentError, "inline must be right or left") unless inline.nil? || %w[right left].any?(inline)
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
        c << classes if classes.present?
      end
    end
  end
end
