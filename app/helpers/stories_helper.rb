module StoriesHelper
  def story_heading(front_matter)
    delimiter = ("," + tag.br + "\n").html_safe

    tag.h2 do
      safe_join(
        [front_matter.dig("story", "teacher"), front_matter.dig("story", "position")].compact,
        delimiter,
      )
    end
  end

  def story_image_alt(name)
    "A photograph of #{name}"
  end

  def youtube(url)
    tag.iframe(
      "",
      width: 560,
      height: 315,
      src: url,
      frameborder: 0,
      allow: "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture",
      allowfullscreen: true,
      class: "story__video",
    )
  end

  def more_stories_thumbnail(path)
    tag.div(
      class: "more-stories__thumbs__thumb__img",
      style: %(background-image:url('#{path}')),
    )
  end
end
