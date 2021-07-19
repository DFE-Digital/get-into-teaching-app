module MetadataHelper
  include Webpacker::Helper

  def meta_tag(key:, value:, opengraph: false)
    return if value.blank?

    tag.meta(name: prepend_opengraph(key, opengraph), content: value)
  end

  def image_meta_tags(base_url:, value:, opengraph: true)
    return if value.blank?

    image_url = "#{base_url}#{asset_pack_path(value)}"

    safe_join([
      meta_tag(key: "image", value: image_url, opengraph: opengraph),
      meta_tag(key: "image:alt", value: "Photograph of teaching taking place in a classroom", opengraph: opengraph),
    ])
  end

private

  def prepend_opengraph(key, opengraph)
    opengraph ? %(og:#{key}) : key
  end
end
