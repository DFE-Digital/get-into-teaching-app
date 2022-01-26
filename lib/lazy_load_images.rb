class LazyLoadImages
  # Used as a placeholder to prevent invalid HTML.
  TINY_GIF = "data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==".freeze

  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)

    doc.css("picture").each do |picture|
      next if picture.css("img[data-lazy-disable]").any?

      picture.parent.add_child(noscript_picture(picture, doc))

      picture.css("source").each do |source|
        source["data-srcset"] = source.attribute("srcset")
        source["srcset"] = TINY_GIF
      end
    end

    doc.css("picture:not(.no-js) img").each do |img|
      next if img["data-lazy-disable"].present?

      img["data-src"] = img.attribute("src")
      img["src"] = TINY_GIF

      img["class"] ||= ""
      img["class"] = img["class"] << " lazyload"
    end

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

private

  def noscript_picture(picture, doc)
    Nokogiri::XML::Node.new("noscript", doc) do |noscript|
      no_js_picture = picture.dup
      no_js_picture["class"] = "no-js"
      noscript.add_child(no_js_picture)
    end
  end
end
