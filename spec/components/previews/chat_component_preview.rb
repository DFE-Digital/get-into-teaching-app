class ChatComponentPreview < ViewComponent::Preview
  def with_default
    render(ChatComponent.new)
  end
end
