class DesignSystem::MarkdownRenderer < Redcarpet::Render::HTML
  def block_code(code, language)
    "<pre><code class=\"#{language}\">#{CGI::escapeHTML(code)}</code></pre>"
  end
  
  def paragraph(text)
    process_custom_tags("<p>#{text.strip}</p>\n")
  end

  private 

  def process_custom_tags(text)
    if matches = text.match(/(\[button )(.+)(\])/)
      return DesignSystem::Components::Button::Helper.button_tag(matches[2])
    end

    text
  end
end