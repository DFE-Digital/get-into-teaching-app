module Content
  class YoutubeVideoComponent < ViewComponent::Base
    attr_reader :id, :title, :preview_image

    def initialize(id:, title:, preview_image: nil)
      super

      @id = id
      @title = title
      @preview_image = preview_image
    end

    def src
      "https://www.youtube-nocookie.com/embed/#{id}?autoplay=#{autoplay}&mute=#{mute}"
    end

    def preview
      return nil if preview_image.blank?

      tag.a(**preview_link_args) do
        image_pack_tag(preview_image, alt: helpers.image_alt(preview_image))
      end
    end

    def video
      tag.iframe(
        title: title,
        loading: "lazy",
        src: src,
        frameborder: 0,
        allow: "autoplay; encrypted-media",
        allowfullscreen: true,
        data: {
          "youtube-video-target": "video",
        },
      )
    end

  private

    def autoplay
      preview ? 1 : 0
    end

    def mute
      # Modern browsers don't allow you to autoplay a video
      # with sound enabled, so we have to mute.
      preview ? 1 : 0
    end

    def preview_link_args
      {
        href: "javascript:void(0)",
        data: {
          action: "youtube-video#play",
          "youtube-video-target": "preview",
        },
        class: "hidden",
      }
    end

    def before_render
      validate!
    end

    def validate!
      %i[id title].each do |required_attr|
        error_message = "#{required_attr} must be present"
        fail(ArgumentError, error_message) if send(required_attr).blank?
      end
    end
  end
end
