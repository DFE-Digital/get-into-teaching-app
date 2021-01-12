class Search
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :search

  def results
    return nil if search.blank?

    @results ||= search_frontmatter
  end

private

  def search_frontmatter
    Pages::Frontmatter.list.select do |_path, frontmatter|
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
end
