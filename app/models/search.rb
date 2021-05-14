class Search
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :search

  def results
    return nil if search.blank?

    @results ||= search_frontmatter
  end

  NON_CONTENT_PAGES = {
    "/events" => {
      title: "Find an event near you",
      keywords: %w[events conferences presentation],
    },
  }.freeze

private

  def search_frontmatter
    searchable_pages.select do |_path, frontmatter|
      keywords_match?(frontmatter[:keywords]) || title_matches?(frontmatter[:title])
    end
  end

  def keywords_match?(keywords)
    Array.wrap(keywords).any? do |keyword|
      keyword.downcase.starts_with? search.downcase
    end
  end

  def title_matches?(title)
    title.to_s.downcase.match? title_match_regex
  end

  def title_match_regex
    @title_match_regex ||= %r{\b#{Regexp.quote search.downcase}}
  end

  def searchable_pages
    NON_CONTENT_PAGES.merge(Pages::Frontmatter.list)
  end
end
