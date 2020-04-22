module ApplicationHelper
  def page_title
    # FIXME needs to parse front matter
    @page_title || params[:page].to_s.humanize
  end

  def prefixed_page_title
    if page_title.present?
      "Get into teaching: #{page_title}"
    else
      "Get into teaching"
    end
  end

  def header_image
    # FIXME needs to parse frontpatter
    'media/images/main-header.jpg'
  end
end
