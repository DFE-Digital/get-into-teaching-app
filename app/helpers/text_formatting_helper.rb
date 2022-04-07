module TextFormattingHelper
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper

  def safe_format(content)
    simple_format strip_tags content
  end

  def safe_html_format(html)
    sanitize html, tags: %w[link strong a ul li p b br div span h1 h2 h3 h4 h5], attributes: %w[href target rel]
  end
end
