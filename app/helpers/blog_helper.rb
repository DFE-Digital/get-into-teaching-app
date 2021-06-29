module BlogHelper
  def format_blog_date(date_string)
    Date.parse(date_string).to_formatted_s(:govuk_date_long)
  end
end
