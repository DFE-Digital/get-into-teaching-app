# ImageSizes will automatically add width/height attributes to img
# elements in an effort to combat Cumulative Layout Shift (CLS).
#
# If the image src is a path (as it is in local/development environments)
# then we need to prefix the path with "public" as FastImage will peform
# a File.read in this scenario (and our assets are compiled into public/).
class ImageSizes
  @@cache = {}

  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)
    doc.css("img").each do |img|
      next if img["width"] && img["height"]

      auto_size(img)
    end

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

  def self.cache
    @@cache
  end

  def self.cache_image_size(src)
    return @@cache[src] if @@cache.key?(src)

    @@cache[src] = FastImage.size(src, raise_on_failure: false, timeout: 1)
  end

private

  def auto_size(img)
    src = prefix_path(img["src"])
    size = self.class.cache_image_size(src)

    return if size.blank?

    img["width"], img["height"] = size
  end

  def prefix_path(src)
    src.start_with?("http") ? src : "public#{src}"
  end
end
