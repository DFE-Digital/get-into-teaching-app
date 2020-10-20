class Acronyms
  ABBR_REGEXP = %r{\b([A-Z][A-Z]+)\b}.freeze

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
        matched = acronym_for(acronym)
        next unless matched

        replacements += 1
        matched
      end

      node.replace(replacement) unless replacements.zero?
    end
  end

  def acronym_for(acronym)
    if @acronyms.key? acronym
      "<abbr title=\"#{@acronyms[acronym]}\">#{acronym}</abbr>"
    end
  end
end
