class NextGenImages
  # As we control the conversion we only need to look for
  # a subset of all the possible extensions.
  NEXT_GEN_IMAGE_EXTS = %w[.jp2 .webp].freeze

  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)
    doc.css("img").each do |img|
      img.replace(picture(img, doc)) unless img.parent.name == "picture"
    end

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

private

  def picture(img, doc)
    src = img.attribute("src")

    Nokogiri::XML::Node.new("picture", doc) do |picture|
      picture.add_child(img.dup)
      source_exts = [File.extname(src)] + NEXT_GEN_IMAGE_EXTS
      source_exts.each do |ext|
        source = source(src, ext, doc)
        picture.add_child(source) if source.present?
      end
    end
  end

  def source(original_src, ext, doc)
    src = "#{File.basename(original_src, '.*')}#{ext}"

    # File.exist? should work here but doesn't; for some reason
    # File.file? appears to work correctly.
    return nil unless File.file?("#{Rails.public_path}/#{src}")

    Nokogiri::XML::Node.new("source", doc) do |source|
      source.set_attribute("srcset", src)
      source.set_attribute("type", mime_type(src))
    end
  end

  def mime_type(src)
    ext = File.extname(src)

    case ext
    when ".webp"
      # Rack::Mime.mime_type is returning the wrong mime type for webp.
      "image/webp"
    else
      Rack::Mime.mime_type(ext)
    end
  end
end
