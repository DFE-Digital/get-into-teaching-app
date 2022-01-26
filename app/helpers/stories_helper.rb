module StoriesHelper
  def story_heading(teacher, position)
    delimiter = ",#{tag.br}\n".html_safe

    tag.h2 { safe_join([teacher, position].compact, delimiter) }
  end

  def story_image_alt(name)
    "A photograph of #{name}"
  end

  def youtube(url)
    tag.iframe(
      "",
      width: 560,
      height: 315,
      data: { src: url },
      allow: "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture",
      allowfullscreen: true,
      class: "story__video lazyload",
      loading: "lazy",
    )
  end

  def more_stories_thumbnail(path)
    tag.div(
      class: "stories__thumbs__thumb__img",
      style: %(background-image:url('#{path}')),
    )
  end
end
