require "asset_files"

# Responsive images are automatically loaded according to
# the convention:
#
# /path/to/image--<breakpoint>.ext
#
# For example, if a default image exists:
#
# /path/to/image.png
#
# You can ensure a tablet version is displayed on all devices
# that have a viewport < 768px by creating the file:
#
# /path/to/image--tablet.png
class ResponsiveImages
  attr_reader :doc

  BREAKPOINTS = {
    mobile: "500px",
    tablet: "768px",
    desktop: "1000px",
    wide: "1500px",
  }.freeze

  def initialize(doc)
    @doc = doc
  end

  def process
    doc.css("picture source").each do |source|
      BREAKPOINTS.each do |breakpoint, max_width|
        prepend_responsive_source(source, breakpoint, max_width)
      end
    end

    doc
  end

private

  def prepend_responsive_source(source, breakpoint, max_width)
    responsive_src = responsive_src(source["srcset"], breakpoint)
    return if responsive_src.blank?

    responsive_source = source.dup
    responsive_source["srcset"] = responsive_src
    responsive_source["media"] = "(max-width: #{max_width})"

    source.add_previous_sibling(responsive_source)
  end

  def responsive_src(src, breakpoint)
    src_uri = URI.parse(src)

    file_path = responsive_file(src_uri.path, breakpoint)

    return nil if file_path.nil?

    base_url = src_uri.absolute ? "#{src_uri.scheme}://#{src_uri.host}" : ""

    "#{base_url}#{file_path}"
  end

  def responsive_file(src, breakpoint)
    ext = File.extname(src)

    basename = src.sub(/-[^-]*#{ext}$/, "")

    AssetFiles.sibling_url_path(basename, "--#{breakpoint}", ext)
  end
end
