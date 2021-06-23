module TextFormattingHelper
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper

  def safe_format(content)
    simple_format strip_tags content
  end

  def safe_html_format(html)
    sanitize html, tags: %w[strong a ul li p b br div span], attributes: %w[href target]
  end
end
