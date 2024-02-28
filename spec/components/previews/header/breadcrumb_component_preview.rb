class Header::BreadcrumbComponentPreview < ViewComponent::Preview
  def default
    render(Header::BreadcrumbComponent.new)
  end
end
