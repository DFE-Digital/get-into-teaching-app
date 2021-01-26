class Search
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :search

  def results
    return nil if search.blank?

    @results ||= Pages::Frontmatter.list.select do |_path, frontmatter|
      Array.wrap(frontmatter[:keywords]).any? do |keyword|
        keyword.downcase.starts_with? search.downcase
      end
    end
  end
end
