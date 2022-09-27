class ErrorTitle
  def initialize(page)
    @page = page
  end

  def html
    doc = Nokogiri::HTML(@page)
    error = doc.at_css(".govuk-error-summary")

    prefix_title(doc) if error.present?

    doc.to_html(encoding: "UTF-8", indent: 2)
  end

private

  def prefix_title(doc)
    title = doc.at_css("title")
    title.content = "Error: #{title.text}"
  end
end
