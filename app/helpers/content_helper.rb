module ContentHelper
  def article_classes(front_matter)
    ["markdown", front_matter["article_classes"]].flatten.compact.tap do |classes|
      classes << "fullwidth" if front_matter["full_width"]
    end
  end
end
