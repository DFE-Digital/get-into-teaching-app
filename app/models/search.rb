require "stopwords"

class Search
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :search, :string

  # Any non-word character, excluding
  # joining characters ', - and &
  WORD_BOUNDARY = /[^\w'-\\&]+/.freeze
  MAX_LEVENSHTEIN_DISTANCE = 1
  LEVENSHTEIN_MIN_WORD_LENGTH = 6
  KEYWORD_WEIGHTING = 2
  NON_CONTENT_PAGES = {
    "/events" => {
      title: "Find an event near you",
      keywords: %w[event events conference presentation virtual online TTT Q&A attend training],
    },
  }.freeze

  def results
    return nil if tokens.empty?

    @results ||= perform_search
  end

private

  def perform_search
    ranked_pages
      .reject { |page| page[:rank] < 1 }
      .sort_by { |page| page[:rank] }
      .reverse
  end

  def tokens
    @tokens ||= words(search)
  end

  def ranked_pages
    searchable_pages.map do |path, frontmatter|
      keywords = words(Array.wrap(frontmatter[:keywords]).join(" "))
      title_words = words(frontmatter[:title])
      rank = (count_matches(keywords) * KEYWORD_WEIGHTING) + count_matches(title_words)

      {
        rank: rank,
        path: path,
        frontmatter: frontmatter,
      }
    end
  end

  def count_matches(keywords)
    keywords.count do |keyword|
      tokens.any? do |token|
        keyword.start_with?(token) || (
          keyword.length >= LEVENSHTEIN_MIN_WORD_LENGTH &&
          Text::Levenshtein.distance(token, keyword) <= MAX_LEVENSHTEIN_DISTANCE
        )
      end
    end
  end

  def words(text)
    text
      .to_s
      .split(WORD_BOUNDARY)
      .map(&:downcase)
      .reject { |w| ::Stopwords::EN.include?(w) || w.blank? }
  end

  def searchable_pages
    NON_CONTENT_PAGES.merge(Pages::Frontmatter.list)
  end
end
