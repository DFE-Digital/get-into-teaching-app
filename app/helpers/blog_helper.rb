module BlogHelper
  def format_blog_date(date_string)
    Date.parse(date_string).to_formatted_s(:govuk_zero_pad)
  end

  def thumbnail_image_from_post(images)
    first_image_params = images.values.first.symbolize_keys

    if first_image_params.key?(:thumbnail_path)
      first_image_params[:path] = first_image_params[:thumbnail_path]
    end

    render Content::ImageComponent.new(**first_image_params.slice(:path))
  end
end
