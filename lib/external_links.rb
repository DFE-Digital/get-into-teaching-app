class ExternalLinks
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    links = doc.css("a:not(.button)")

    links.each do |anchor|
      next unless external_link?(anchor) && needs_visually_hidden?(anchor)

      anchor.add_child(%{<span class="visually-hidden">(opens in new window)</span>})
    end

    doc
  end

private

  def needs_visually_hidden?(anchor)
    anchor.css(".visually-hidden").empty?
  end

  def external_link?(anchor)
    anchor[:href]&.include?("//")
  end
end
