module StoriesHelper
  def story_heading(front_matter)
    tag.h2 do
      safe_join(
        [
          front_matter.dig("story", "teacher"),
          ",",
          tag.br,
          front_matter.dig("story", "position"),
        ],
      )
    end
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
