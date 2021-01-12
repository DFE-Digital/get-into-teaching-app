class Search
  attr_reader :results

  def initialize(term)
    @results = term.present? ? [] : nil
  end
end
