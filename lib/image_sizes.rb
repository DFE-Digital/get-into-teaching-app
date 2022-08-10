# ImageSizes will automatically add width/height attributes to img
# elements in an effort to combat Cumulative Layout Shift (CLS).
class ImageSizes
  @@cache = {}

  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)
    doc.css("img").each do |img|
      next if sized?(img)
      next unless enabled? && sizable?(img["src"])

      size_image(img)
    end

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

  class << self
    def cache
      @@cache
    end

    def cache_image_size(src)
      @@cache[src] ||= FastImage.size(src, raise_on_failure: false, timeout: timeout)
    end

    def timeout
      ENV["FAST_IMAGE_TIMEOUT"]
    end
  end

private

  def enabled?
    ActiveModel::Type::Boolean.new.cast(ENV["SIZE_IMAGES"])
  end

  def sized?(img)
    img["width"] && img["height"]
  end

  # We only want to size images we control (to avoid
  # downloading something malicious onto the server).
  def sizable?(src)
    uri = URI.parse(src)

    # All local images are sizable.
    return true if uri.scheme.nil?

    # Only size images from our own asset host.
    asset_host&.include?(uri.host)
  end

  def size_image(img)
    src = prefix_path(img["src"])
    size = self.class.cache_image_size(src)

    return if size.blank?

    img["width"], img["height"] = size
  end

  def asset_host
    ENV["APP_ASSETS_URL"]
  end

  # If the image src is a path (as it is in local/development environments)
  # then we need to prefix the path with "public" as FastImage will peform
  # a File.read in this scenario (and our assets are compiled into public/).
  def prefix_path(src)
    src.start_with?("http") ? src : "public#{src}"
  end
end
