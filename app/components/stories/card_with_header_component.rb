module Stories
  class CardWithHeaderComponent < CardComponent
    attr_reader :page_data
    with_collection_parameter :card

    def initialize(card:, page_data: nil)
      @page_data = page_data
      super card: card
    end

    def border
      false
    end

    def header
      @header ||= lookup_header
    end

  private

    def lookup_header
      return unless page_data

      page_data.find_page(link)[:title]
    rescue Pages::Frontmatter::NotMarkdownTemplate
      nil
    end
  end
end
