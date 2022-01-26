module MetadataHelper
  include Webpacker::Helper

  def meta_tag(key:, value:, opengraph: false)
    return if value.blank?

    tag.meta(name: prepend_opengraph(key, opengraph), content: value)
  end

  def image_meta_tags(image_path:, alt:, opengraph: true)
    return if image_path.blank?

    image_url = asset_pack_url(image_path)

    safe_join([
      meta_tag(key: "image", value: image_url, opengraph: opengraph),
      meta_tag(key: "image:alt", value: alt, opengraph: opengraph),
    ])
  end

private

  def prepend_opengraph(key, opengraph)
    opengraph ? %(og:#{key}) : key
  end
end
