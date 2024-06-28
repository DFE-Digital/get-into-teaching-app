class ErrorTitle
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    error = doc.at_css(".govuk-error-summary")

    prefix_title(doc) if error.present?

    doc
  end

private

  def prefix_title(doc)
    title = doc.at_css("title")
    title.content = "Error: #{title.text}"
  end
end
