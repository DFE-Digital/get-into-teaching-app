module SearchHelper
  def display_search_path(path)
    humanized_path = humanize_path(path)

    return unless humanized_path

    tag.span(humanized_path, class: "search-result__path")
  end
end
