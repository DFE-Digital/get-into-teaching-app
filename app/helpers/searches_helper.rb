module SearchesHelper
  def humanize_path(path, separator: " ", &block)
    formatter = block_given? ? block : method(:humanize_path_segment)

    safe_join path.split("/").slice(1...-1).map(&formatter), separator
  end

  def humanize_path_segment(segment)
    tag.span do
      safe_join [segment.humanize.gsub("-", " "), " &rsaquo;".html_safe]
    end
  end
end
