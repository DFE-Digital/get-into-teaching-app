class AccessibleFootnotes
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    doc.css("a.footnote").each do |footnote|
      footnote.prepend_child(accessible_prefix(doc, "Footnote "))
    end

    doc.css("a.reversefootnote").each do |footnote|
      number = footnote["href"].scan(%r{\d+}).first
      footnote.prepend_child(accessible_prefix(doc, "Location of footnote #{number}"))
    end

    doc
  end

private

  def accessible_prefix(doc, prefix)
    Nokogiri::XML::Node.new("span", doc) do |span|
      span["class"] = "visually-hidden"
      span.content = prefix
    end
  end
end
