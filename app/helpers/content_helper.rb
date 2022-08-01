module ContentHelper
  def article_classes(front_matter)
    ["markdown", front_matter["article_classes"]].flatten.compact.tap do |classes|
      classes << "fullwidth" if front_matter["fullwidth"]
    end
  end

  def display_content_errors?
    Rails.application.config.x.display_content_errors
  end
end
