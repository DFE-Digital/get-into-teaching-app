class LazyLoadImages
  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)

    doc.css("img").each do |img|
      img.after(noscript_image(img, doc))
      img.set_attribute("data-src", img.attribute("src"))
      img.remove_attribute("src")
      img["class"] ||= ""
      img["class"] = img["class"] << " lazyload"
    end

    doc.css("picture source").each do |source|
      source.set_attribute("data-srcset", source.attribute("srcset"))
      source.remove_attribute("srcset")
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
