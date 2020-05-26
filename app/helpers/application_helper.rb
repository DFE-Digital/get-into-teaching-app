module ApplicationHelper
  def page_title(title, frontmatter)
    frontmatter ||= {}
    title || frontmatter["title"] || params[:page].to_s.humanize
  end

  def prefix_title(title)
    if title
      "Get into teaching: #{title}"
    else
      "Get into teaching"
    end
  end

  def header_image
    # FIXME needs to parse frontpatter
    "media/images/main-header.jpg"
  end

  def hero_image_path(imgpath)
    if imgpath =~ %r(^/assets/)
      imgpath
    else
      asset_pack_path(imgpath)
    end
  end
end
