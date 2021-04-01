module MetadataHelper
  def meta_tag(key:, value:, opengraph: false)
    return if value.blank?

    tag.meta(name: prepend_opengraph(key, opengraph), content: value)
  end

private

  def prepend_opengraph(key, opengraph)
    opengraph ? %(og:#{key}) : key
  end
end
