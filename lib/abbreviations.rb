class Abbreviations
  ABBR_REGEXP = %r{\b([A-Z][A-Z]+)\b}.freeze

  def initialize(content, abbreviations)
    @document = parse_html(content)
    @abbreviations = abbreviations || {}
  end

  def render
    @document.tap(&method(:replace_abbreviations)).to_html
  end

private

  def parse_html(content)
    Nokogiri::HTML::DocumentFragment.parse(content)
  end

  def replace_abbreviations(document)
    document.traverse do |node|
      next unless node.text?

      replacements = 0
      replacement = node.content.gsub(ABBR_REGEXP) do |abbr|
        matched = abbreviation_for(abbr)
        next unless matched

        replacements += 1
        matched
      end

      node.replace(replacement) unless replacements.zero?
    end
  end

  def abbreviation_for(abbr)
    if @abbreviations.key? abbr
      "<abbr title=\"#{@abbreviations[abbr]}\">#{abbr}</abbr>"
    end
  end
end
