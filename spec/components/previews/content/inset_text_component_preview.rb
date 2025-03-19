class Content::InsetTextComponentPreview < ViewComponent::Preview
  def default
    component = Content::InsetTextComponent.new(**text)
    render(component)
  end

private

  def text
    {
      text: "<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. "\
      "Praesent a nisl semper, efficitur velit ac, tincidunt arcu.</p>"\
      "<p>Morbi non nisl eu arcu molestie lacinia <a href=\"#\">quis quis</a> libero.</p>"\
      "<p><a href=\"#\">Link</a></p>",
    }
  end
end
