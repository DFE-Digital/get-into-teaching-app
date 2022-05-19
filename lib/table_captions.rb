class TableCaptions
  # This should match:
  #
  # <p>Table caption: my caption</p>
  #
  # And move it to become the caption of the preceeding table.
  #
  #  e.g., given the html:
  #
  # <table>
  # </table>
  # <p>Table caption: my caption</p>
  #
  # It will render:
  #
  # <table>
  # <caption>my caption</caption>
  # </table>
  TABLE_CAPTION_PREFIX = "Table caption: ".freeze

  def initialize(content)
    @document = parse_html(content)
  end

  def render
    @document.tap(&method(:caption_tables)).to_html
  end

private

  def parse_html(content)
    Nokogiri::HTML::DocumentFragment.parse(content)
  end

  def table_caption?(node)
    node.previous_element&.name == "table" &&
      node.content&.start_with?(TABLE_CAPTION_PREFIX)
  end

  def table_caption(node)
    "<caption>#{node.content.delete_prefix(TABLE_CAPTION_PREFIX)}</caption>"
  end

  def caption_tables(document)
    document.traverse do |node|
      next unless table_caption?(node)

      node.previous_element.prepend_child(table_caption(node))
      node.remove
    end
  end
end
