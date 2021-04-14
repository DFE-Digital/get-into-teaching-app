class Acronyms
  ABBR_REGEXP = %r{(?<!\()\b([A-Z][A-Z]+)\b(?![\w\s]*[)])}.freeze

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
