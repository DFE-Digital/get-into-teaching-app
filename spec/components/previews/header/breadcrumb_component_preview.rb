class Header::BreadcrumbComponentPreview < ViewComponent::Preview
  def default
    component = Header::BreadcrumbComponent.new
    render(component) do
      add_breadcrumbs(component.controller)
    end
  end

private

  def add_breadcrumbs(controller)
    controller.breadcrumb "Page 1", "/page/1"
    controller.breadcrumb "Page 2", "/page/2"
    controller.breadcrumb "Page 3", "/page/3"
    controller.breadcrumb "Current Page", controller.request.path
  end
end
