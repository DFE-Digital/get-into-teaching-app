module BlogHelper
  def format_blog_date(date_string)
    Date.parse(date_string).to_formatted_s(:govuk_zero_pad)
  end

  def most_popular_tags(limit = 5)
    Pages::Frontmatter
      .select_by_path("/blog")
      .flat_map { |_path, fm| fm[:tags] }
      .tally
      .sort_by { |tag, count| [-count, tag] }
      .map { |tag, _count| tag }
      .first(limit)
  end
end
