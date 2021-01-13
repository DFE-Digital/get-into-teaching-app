class Search
  attr_reader :search_term

  def initialize(search_term)
    @search_term = search_term.presence
  end

  def results
    return nil unless search_term

    @results ||= Pages::Frontmatter.list.select do |_path, frontmatter|
      Array.wrap(frontmatter[:keywords]).any? do |keyword|
        keyword.downcase.starts_with? search_term.downcase
      end
    end
  end
end
