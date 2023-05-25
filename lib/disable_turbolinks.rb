class DisableTurbolinks
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    doc.css("a[href='/tta-service']").each do |anchor|
      anchor["data-turbolinks"] = false
    end

    doc
  end
end
