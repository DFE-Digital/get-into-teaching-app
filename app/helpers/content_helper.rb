module ContentHelper
  include TemplateHandlers
  def article_classes(front_matter)
    ["markdown", front_matter["article_classes"]].flatten.compact.tap do |classes|
      classes << "fullwidth" if front_matter["fullwidth"]
    end
  end

  def display_content_errors?
    Rails.application.config.x.display_content_errors
  end

  def value(key)
    Value.get(key)
  end
  alias_method :v, :value

  # rubocop:disable Style/PerlBackrefs
  def substitute_values(content)
    content.gsub(Markdown::COMPONENT_PLACEHOLDER_REGEX) { safe_join([value($1)].compact).strip } if content
  end
  # rubocop:enable Style/PerlBackrefs
end
