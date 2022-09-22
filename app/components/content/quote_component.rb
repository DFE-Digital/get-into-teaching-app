module Content
  class QuoteComponent < ViewComponent::Base
    attr_reader :text, :name, :job_title, :cta, :image, :hang, :inline, :background, :links

    def initialize(
      text:,
      name: nil,
      job_title: nil,
      cta: nil,
      image: nil,
      hang: "left",
      inline: nil,
      background: "yellow",
      links: {}
    )
      super

      @text = text
      @name = name
      @job_title = job_title
      @cta = cta
      @image = image
      @hang = hang
      @inline = inline
      @background = background
      @links = links

      fail(ArgumentError, "text must be present") if text.blank?

      cta_malformed = cta.present? && cta.values_at(:title, :link).any?(&:blank?)
      fail(ArgumentError, "cta must contain a title and link") if cta_malformed
      fail(ArgumentError, "hang must be right or left") unless %w[right left].any?(hang)
      fail(ArgumentError, "inline must be right or left") unless inline.nil? || %w[right left].any?(inline)
      fail(ArgumentError, "background must be yellow or white") unless %w[yellow white].any?(background)
      fail(ArgumentError, "links must be a hash") unless links.nil? || links.is_a?(Hash)
    end

    def show_footer?
      footer_attrs = [name, job_title, cta, image]
      footer_attrs.any?(&:present?)
    end

    def cta_title_last_word
      cta[:title].split.last
    end

    def cta_title_sans_last_word
      cta[:title].split[0...-1].join(" ")
    end

    def text_last_word
      text.split.last
    end

    def text_sans_last_word
      text.split[0...-1].join(" ")
    end

    def footer_class
      %w[footer].tap do |c|
        c << "footer--with-image" if image.present?
      end
    end

    def quote_class
      ["quote", "quote--hang-#{hang}"].tap do |c|
        c << "quote--inline-#{inline}" if inline
        c << "quote--background-#{background}" if background
      end
    end
  end
end
