module Values
  include ActionView::Helpers::OutputSafetyHelper

  PLACEHOLDER_REGEX = /\$([A-z0-9-]+)\$/

  def value(key)
    Value.get(key)
  end
  alias_method :v, :value

  def substitute_values(content)
    return content unless content.is_a? String

    substituted = content.gsub(PLACEHOLDER_REGEX) { safe_join([value(::Regexp.last_match(1))].compact).strip } if content
    content.html_safe? ? substituted.html_safe : substituted
  end
end
