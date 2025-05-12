module MetadataHelper
  include Shakapacker::Helper

  def meta_tag(key:, value:, opengraph: false)
    return if value.blank?

    if opengraph
      tag.meta(property: "og:#{key}", content: value)
    else
      tag.meta(name: key, content: value)
    end
  end

  def image_meta_tags(image_path:, opengraph: true)
    return if image_path.blank?

    image_url = asset_pack_url(image_path)

    safe_join([
      meta_tag(key: "image", value: image_url, opengraph: opengraph),
      meta_tag(key: "image:alt", value: Image.new.alt(image_path), opengraph: opengraph),
    ])
  end
end
