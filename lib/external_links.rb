class ExternalLinks
  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)
    links = doc.css("a:not(.button)")

    links.each do |anchor|
      next unless external_link?(anchor) && needs_visually_hidden?(anchor)

      anchor.add_child(%{<span class="visually-hidden">(opens in new window)</span>})
    end

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

private

  def needs_visually_hidden?(anchor)
    anchor.css(".visually-hidden").empty?
  end

  def external_link?(anchor)
    anchor[:href]&.include?("//")
  end
end
