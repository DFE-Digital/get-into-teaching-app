module TextFormattingHelper
  extend ActiveSupport::Concern
  include ActionView::Helpers::TextHelper

  def safe_format(content)
    simple_format strip_tags content
  end
end
