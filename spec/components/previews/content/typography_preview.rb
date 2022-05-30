class Content::TypographyPreview < ViewComponent::Preview
  class TypographyComponent < ViewComponent::Base
    TAGS = %w[h1 h2 h3 h4].freeze

    SIZES = %w[xxl xl l m s].freeze
    MODIFIERS = %w[
      margin-bottom-0
      margin-top-0
      normal
      overlap
      box-blue
      box-green
      box-pink
      box-purple
      box-yellow
      box-white
      box-transparent
      heading--box-padding-l
    ].freeze

    CAPTION_SIZES = %w[xxl l m].freeze
    CAPTION_MODIFIERS = %w[purple bold].freeze

    def call
      previews =
        tags +
        headings +
        modified_headings +
        captioned_headings +
        modified_captioned_headings

      safe_join(previews)
    end

  private

    def tags
      TAGS.map do |h_tag|
        container_tag { tag.send(h_tag, "Heading - #{h_tag}") }
      end
    end

    def headings
      SIZES.map do |size|
        container_tag { tag.h1("Heading - #{size}", class: "heading-#{size}") }
      end
    end

    def modified_headings
      MODIFIERS.map do |modifier|
        container_tag { tag.h1("Heading - m - #{modifier}", class: "heading-m heading--#{modifier}") }
      end
    end

    def container_tag(&block)
      tag.div(style: "border: 1px solid black; margin-bottom: 1em;", &block)
    end

    def captioned_headings
      CAPTION_SIZES.map do |size|
        container_tag do
          tag.h1(class: "heading-#{size}") do
            safe_join([
              tag.div("Captioned", class: "caption-#{size}"),
              tag.span("Heading - #{size}"),
            ])
          end
        end
      end
    end

    def modified_captioned_headings
      CAPTION_MODIFIERS.map do |modifier|
        container_tag do
          tag.h1(class: "heading-m") do
            safe_join([
              tag.div("Captioned", class: "caption-m caption--#{modifier}"),
              tag.span("Heading - m - #{modifier}"),
            ])
          end
        end
      end
    end
  end

  def default
    render TypographyComponent.new
  end
end
