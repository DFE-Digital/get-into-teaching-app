class NextGenImages
  # As we control the conversion we only need to look for
  # a subset of all the possible extensions.
  NEXT_GEN_IMAGE_EXTS = %w[.webp .jp2].freeze

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
    src = img["src"]

    Nokogiri::XML::Node.new("picture", doc) do |picture|
      source_exts = NEXT_GEN_IMAGE_EXTS + [File.extname(src)]
      source_exts.each do |ext|
        source = source(src, ext, doc)
        picture.add_child(source) if source.present?
      end
      picture.add_child(img.dup)
    end
  end

  def source(original_src, ext, doc)
    src_uri = URI.parse(original_src)
    base_url = src_uri.absolute ? "#{src_uri.scheme}://#{src_uri.host}" : ""
    src_path = "#{src_uri.path.chomp(File.extname(original_src))}#{ext}"

    return nil unless File.exist?("#{Rails.public_path}#{src_path}")

    Nokogiri::XML::Node.new("source", doc) do |source|
      source["srcset"] = "#{base_url}#{src_path}"
      source["type"] = mime_type(src_path)
    end
  end

  def mime_type(src)
    ext = File.extname(src)
    Rack::Mime.mime_type(ext)
  end
end
