class Acronyms
  # This should match:
  #
  #  * uppercase strings,
  #  * that are longer than 2+ characters long
  #  * that aren't surrounded by parens
  #
  #  e.g., given the string:
  #
  #  > "A Postgraduate Certificate in Education (PGCE) will help you get QTS."
  #
  # QTS _should_ match but PGCE _shouldn't_.
  ABBR_REGEXP = %r{(?!\()\b([A-Z]{2,})\b(?![\w\s]*\))}.freeze

  def initialize(content, acronyms)
    @document = parse_html(content)
    @acronyms = acronyms || {}
  end

  def render
    @document.tap(&method(:replace_acronyms)).to_html
  end

private

  def parse_html(content)
    Nokogiri::HTML::DocumentFragment.parse(content)
  end

  def replace_acronyms(document)
    document.traverse do |node|
      next unless node.text?
      next unless node.parent.name == "p"

      replacements = 0
      replacement = node.content.gsub(ABBR_REGEXP) do |acronym|
        expanded = acronym_for(acronym)
        next acronym unless expanded

        replacements += 1
        expanded
      end

      node.replace(replacement) if replacements.positive?
    end
  end

  def acronym_for(acronym)
    if @acronyms.key? acronym
      "<abbr title=\"#{@acronyms[acronym]}\">#{acronym}</abbr>"
    end
  end
end
