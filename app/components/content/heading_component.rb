module Content
  class HeadingComponent < ViewComponent::Base
    attr_reader :heading,
                :tag,
                :heading_size,
                :caption,
                :caption_size,
                :caption_bold,
                :caption_purple

    def initialize(
      heading: nil,
      tag: :h1,
      heading_size: nil,
      caption: nil,
      caption_size: nil,
      caption_bold: true,
      caption_purple: true,
      **kwargs
    )
      super

      @heading = heading
      @heading_size = heading_size
      @caption = caption
      @caption_size = caption_size
      @caption_bold = caption_bold
      @caption_purple = caption_purple
      @tag = tag
      @kwargs = kwargs || {}
    end

    def call
      safe_join(
        [
          (content_tag(:span, caption, class: caption_classes) if caption),
          content_tag(tag, content_tag(:span, heading), **kwargs),
        ],
      )
    end

    def render?
      heading.present?
    end

    def before_render
      validate!
    end

  private

    def validate!
      fail(ArgumentError, "heading_size must be :s, :m, :l, :xl or :xxl") unless heading_size.nil? || heading_size.in?(%i[s m l xl xxl])
      fail(ArgumentError, "tag must be :h1, :h2, :h3 or :h4") unless tag.in?(%i[h1 h2 h3 h4])
      fail(ArgumentError, "caption_size must be :m, :l or :xxl") unless caption_size.nil? || caption_size.in?(%i[m l xxl])
    end

    def kwargs
      @kwargs.tap do |h|
        h[:class] = Array.wrap(@kwargs[:class]).tap do |c|
          c << "heading-#{heading_size}" if heading_size
          c << "heading--with-caption" if caption
        end
      end
    end

    def caption_classes
      [].tap do |c|
        c << "caption-#{caption_size}" if caption_size
        c << "caption--bold" if caption_bold
        c << "caption--purple" if caption_purple
      end
    end
  end
end
