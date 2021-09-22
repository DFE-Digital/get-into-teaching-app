class LazyLoadImages
  # Used as a placeholder to prevent invalid HTML.
  TINY_GIF = "data:image/gif;base64,R0lGODlhAQABAAD/ACwAAAAAAQABAAACADs=".freeze

  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)

    doc.css("img").each do |img|
      next if img["data-lazy-disable"].present?

      img.after(noscript_image(img, doc))

      img["data-src"] = img.attribute("src")
      img["src"] = TINY_GIF

      img["class"] ||= ""
      img["class"] = img["class"] << " lazyload"
    end

    doc.css("picture").each do |picture|
      next if picture.css("img[data-lazy-disable]").any?

      picture.css("source").each do |source|
        source["data-srcset"] = source.attribute("srcset")
        source["srcset"] = TINY_GIF
      end
    end

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

private

  def noscript_image(img, doc)
    Nokogiri::XML::Node.new("noscript", doc) do |noscript|
      noscript.add_child(img.dup)
    end
  end
end
