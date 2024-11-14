class NewTabLinks
  attr_reader :doc

  def initialize(doc)
    @doc = doc
  end

  def process
    links = doc.css("a.new-tab")

    links.each do |anchor|
      unless anchor["class"]&.include?("button")
        anchor.add_child(%{ <span>(opens in new tab)</span>})
      end

      anchor[:target] = "_blank"
      anchor[:rel] = "noopener"
    end

    doc
  end
end
