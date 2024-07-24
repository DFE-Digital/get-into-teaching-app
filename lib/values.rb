module Values
  PLACEHOLDER_REGEX = /\$([A-z0-9-]+)\$/

  def value(key)
    Value.get(key)
  end
  alias_method :v, :value

  # rubocop:disable Style/PerlBackrefs
  def substitute_values(content)
    content.gsub(PLACEHOLDER_REGEX) { safe_join([value($1)].compact).strip } if content
  end
  # rubocop:enable Style/PerlBackrefs
end
