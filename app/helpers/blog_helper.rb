module BlogHelper
  def format_blog_date(date_string)
    Date.parse(date_string).to_formatted_s(:govuk_zero_pad)
  end

  def first_image_from_post(images)
    first_image_params = images.values.first.symbolize_keys

    render Content::ImageComponent.new(**first_image_params)
  end
end
